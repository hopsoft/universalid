# frozen_string_literal: true

if defined? ActiveRecord

  class UniversalID::Contrib::ActiveRecordBasePacker
    using UniversalID::Refinements::HashRefinement

    # TODO: implement support for has_one
    #       ActiveRecord::Reflection::HasOneReflection
    #
    # TODO: implement support for has_and_belongs_to_many
    #       ActiveRecord::Reflection::HasAndBelongsToManyReflection
    #
    HAS_MANY_ASSOCIATIONS = [
      ActiveRecord::Reflection::HasManyReflection
    ]

    DESCENDANTS_KEY = "uid:descendants"

    attr_reader :record

    def initialize(record)
      @record = record
    end

    def pack_with(packer)
      packer.write record.class.name
      packer.write packable_attributes
    end

    def prepack_options
      options = record.instance_variable_get(:@_uid_prepack_options)
      options = UniversalID::PrepackOptions.new unless options.is_a?(UniversalID::PrepackOptions)
      options
    end

    def prepack_database_options
      prepack_options.database_options
    end

    private

    def packable_attributes
      hash = if id_only?
        record.attributes.slice record.class.primary_key
      else
        record.attributes.select { |name, _| prepack_options.keep_key? name }.tap do |attrs|
          reject_keys! attrs if prepack_database_options.exclude_keys?
          reject_timestamps! attrs if prepack_database_options.exclude_timestamps?
          reject_unsaved_changes! attrs if prepack_database_options.exclude_changes?
        end
      end

      if include_descendants?
        add_descendants! hash
        hash.delete DESCENDANTS_KEY if hash[DESCENDANTS_KEY].empty?
      end

      hash["marked_for_destruction"] = true if record.marked_for_destruction?

      hash.prepack prepack_options
    end

    # helpers ..................................................................................................
    def id_only?
      return false if record.new_record?

      # explicit exclusion of primary key
      return false if prepack_options.reject_key?(record.class.primary_key)

      # explicit exclusion of all db keys and primary key is not explicitly included
      return false if prepack_database_options.exclude_keys? && !prepack_options.keep_key?(record.class.primary_key)

      # non-pk attribute names
      attribute_names = record.attributes.keys - [record.class.primary_key]

      # explicit inclusion of non-pk attributes
      return false if prepack_options.includes.any? && attribute_names.any? { |attr| prepack_options.includes[attr] }

      # record has unsaved non-pk changes and we want to keep them
      return false if prepack_database_options.include_changes? && attribute_names.any? { |attr| record.changes[attr] }

      prepack_database_options.include_keys?
    end

    def include_descendants?
      return false unless prepack_database_options.include_descendants?

      max_depth = prepack_database_options.descendant_depth.to_i
      record_depth = record.instance_variable_get(:@_uid_depth).to_i
      record_depth < max_depth
    end

    # attribute mutators .......................................................................................

    def reject_keys!(hash)
      hash.delete record.class.primary_key unless prepack_options.includes[record.class.primary_key]
      foreign_key_column_names.each { |key| hash.delete(key) unless prepack_options.includes[key] }
    end

    def reject_timestamps!(hash)
      timestamp_column_names.each { |key| hash.delete key unless prepack_options.includes[key] }
    end

    def reject_unsaved_changes!(hash)
      record.changes_to_save.each do |key, (original_value, _)|
        hash[key] = original_value if prepack_options.keep_key?(key)
      end
    end

    def add_descendants!(hash)
      hash[DESCENDANTS_KEY] ||= {}

      has_many_descendant_instances_by_association_name.each do |name, relation|
        descendants = relation.each_with_object([]) do |descendant, memo|
          next unless descendant.persisted? || prepack_database_options.include_changes?

          descendant.instance_variable_set(:@_uid_depth, prepack_database_options.current_depth + 1)
          prepacked = UniversalID::Prepacker.prepack(descendant, prepack_options.to_h)
          memo << UniversalID::MessagePackFactory.msgpack_pool.dump(prepacked)
        ensure
          prepack_database_options.decrement_current_depth!
          descendant.remove_instance_variable :@_uid_depth
        end
        hash[DESCENDANTS_KEY][name.to_s] = descendants
      end

      prepack_database_options.increment_current_depth!
    end

    # active record helpers ....................................................................................

    def timestamp_column_names
      record.class.all_timestamp_attributes_in_model
    end

    def foreign_key_column_names
      record.class.reflections
        .each_with_object([]) do |(name, reflection), memo|
          memo << reflection.foreign_key if reflection.macro == :belongs_to
        end
    end

    def associations
      record.class.reflect_on_all_associations
    end

    def has_many_associations
      associations.select { |a| HAS_MANY_ASSOCIATIONS.include? a.class }
    end

    # Returns a has of the current in-memory `has_many` associated records keyed by name
    def has_many_descendant_instances_by_association_name
      has_many_associations.each_with_object({}) do |association, memo|
        relation = record.public_send(association.name)

        descendants = Set.new

        # persisted records
        relation.each { |descendant| descendants << descendant } if relation.loaded?

        # new records
        relation.target.each { |descendant| descendants << descendant } if relation.target.any?

        memo[association.name] = descendants.to_a if descendants.any?
      end
    end
  end

end
