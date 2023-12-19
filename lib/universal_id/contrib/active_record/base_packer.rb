# frozen_string_literal: true

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
    return record.attributes.slice(record.class.primary_key) if id_only?(prepack_database_options)

    hash = record.attributes

    if !record.changed? && prepack_database_options.include_keys?
      keys = prepack_options.includes.none? ? [] : hash.keys.select { |key| prepack_options.keep_key? key }
      keys.prepend record.class.primary_key
      hash = hash.slice(*keys)
    end

    reject_keys! hash if prepack_database_options.exclude_keys?
    reject_timestamps! hash if prepack_database_options.exclude_timestamps?
    reject_unsaved_changes! hash if prepack_database_options.exclude_unsaved_changes?
    add_descendants! hash if include_descendants?

    hash.prepack prepack_options
  end

  # helpers ..................................................................................................
  def id_only?(prepack_database_options)
    return false if record.new_record?
    return false if prepack_database_options.include_descendants?
    prepack_database_options.exclude_unsaved_changes?
  end

  def include_descendants?
    return false unless prepack_database_options.include_descendants?

    max_depth = prepack_database_options.descendant_depth.to_i
    record_depth = record.instance_variable_get(:@_uid_depth).to_i
    record_depth < max_depth
  end

  # attribute mutators .......................................................................................

  def reject_keys!(hash)
    hash.delete record.class.primary_key
    foreign_key_column_names.each { |key| hash.delete key }
  end

  def reject_timestamps!(hash)
    timestamp_column_names.each { |key| hash.delete key }
  end

  def reject_unsaved_changes!(hash)
    record.changes_to_save.each do |key, (original_value, _)|
      hash[key] = original_value
    end
  end

  def add_descendants!(hash)
    hash[DESCENDANTS_KEY] ||= {}

    loaded_has_many_relations_by_name.each do |name, relation|
      descendants = relation.map do |descendant|
        descendant.instance_variable_set(:@_uid_depth, prepack_database_options.current_depth + 1)
        prepacked = UniversalID::Prepacker.prepack(descendant, prepack_options.to_h)
        UniversalID::MessagePackFactory.msgpack_pool.dump prepacked
      ensure
        prepack_database_options.decrement_current_depth!
        descendant.remove_instance_variable :@_uid_depth
      end
      hash[DESCENDANTS_KEY][name] = descendants
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

  def loaded_has_many_relations_by_name
    has_many_associations.each_with_object({}) do |association, memo|
      relation = record.public_send(association.name)
      next unless relation.loaded?
      memo[association.name] = relation
    end
  end
end
