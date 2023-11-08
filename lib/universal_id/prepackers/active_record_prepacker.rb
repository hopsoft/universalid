# frozen_string_literal: true

# TODO: move prepacking logic to a MessagePack type
# prepack:
#   [x] exclude: []
#   [x] include: []
#   [x] include_blank: true
#
#   database:
#     [x] include_keys: true
#     [x] include_timestamps: true
#     [x] include_unsaved_changes: false
#     [ ] include_descendants: false # TODO: Implement this!
#     [ ] descendant_depth: 0 # TODO: Implement this!
class UniversalID::ActiveRecordPrepacker
  using UniversalID::Refinements::KernelRefinement
  using UniversalID::Refinements::ArrayRefinement
  using UniversalID::Refinements::HashRefinement
  using UniversalID::Refinements::SetRefinement
  using UniversalID::Refinements::OpenStructRefinement

  ID = "9T9fl6" # DO NOT CHANGE THIS VALUE!
  TARGET = "ActiveRecord::Base"

  class << self
    def id
      ID
    end

    def target
      const_find TARGET
    end

    # TODO: add error handling
    def restore(model_name, attributes)
      model = const_find(model_name)

      record = if attributes[model.primary_key]
        model.find_by(id: attributes[model.primary_key])
      else
        model.new
      end

      attributes.each do |key, value|
        record.public_send "#{key}=", value if record.respond_to? "#{key}="
      end

      record
    end
  end

  UniversalID::Prepacker.register self

  attr_reader :model, :record

  def initialize(record)
    @model = record.class
    @record = record
  end

  def prepack(options = {})
    database_options = options.database_options
    return id_attributes if id_only?(database_options)

    hash = record.attributes
    reject_database_keys! hash if database_options.exclude_keys?
    reject_timestamps! hash if database_options.exclude_timestamps?
    discard_unsaved_changes! hash if database_options.exclude_unsaved_changes?

    hash.prepack options
  end

  private

  # attribute mutators .......................................................................................

  def reject_database_keys!(hash)
    hash.delete primary_key_name
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

  def primary_key_name
    model.primary_key
  end

  def timestamp_column_names
    model.all_timestamp_attributes_in_model
  end

  def foreign_key_column_names
    model.reflections
      .each_with_object([]) do |(name, reflection), memo|
        memo << reflection.foreign_key if reflection.macro == :belongs_to
      end
  end

  def id_only?(database_options)
    return false if record.new_record?
    return false if database_options.include_descendants?
    database_options.exclude_unsaved_changes?
  end

  def id_attributes
    {primary_key_name => record.attributes[primary_key_name]}
  end
end
