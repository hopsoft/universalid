# frozen_string_literal: true

# TODO:
#   prepack:
#     [x] exclude: []
#     [x] include: []
#     [x] include_blank: true
#
#     database:
#       [x] include_keys: true
#       [x] include_timestamps: true
#       [x] include_unsaved_changes: false
#       [ ] include_descendants: false
#       [ ] descendant_depth: 0
class UniversalID::ActiveRecordBasePacker
  using UniversalID::Refinements::HashRefinement

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def pack_with(packer)
    packer.write record.class.name
    packer.write packable_attributes
  end

  def prepack_options
    record.instance_variable_get(:@_uid_prepack_options) || UniversalID::PrepackOptions.new
  end

  def prepack_database_options
    prepack_options.database_options
  end

  private

  def packable_attributes
    return record.attributes.slice(record.class.primary_key) if id_only?(prepack_database_options)

    hash = record.attributes
    reject_database_keys! hash if prepack_database_options.exclude_keys?
    reject_timestamps! hash if prepack_database_options.exclude_timestamps?
    discard_unsaved_changes! hash if prepack_database_options.exclude_unsaved_changes?

    hash.prepack prepack_options
  end

  # attribute mutators .......................................................................................

  def reject_database_keys!(hash)
    hash.delete record.class.primary_key
    foreign_key_column_names.each { |key| hash.delete key }
  end

  def reject_timestamps!(hash)
    timestamp_column_names.each { |key| hash.delete key }
  end

  def discard_unsaved_changes!(hash)
    record.changes_to_save.each do |key, (original_value, _)|
      hash[key] = original_value
    end
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

  def id_only?(prepack_database_options)
    return false if record.new_record?
    return false if prepack_database_options.include_descendants?
    prepack_database_options.exclude_unsaved_changes?
  end
end
