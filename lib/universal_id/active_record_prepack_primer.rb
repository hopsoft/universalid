# frozen_string_literal: true

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
class UniversalID::ActiveRecordPrepackPrimer
  MESSAGE_PACK_KEY = Digest::SHA1.hexdigest(name)[0, 8]

  attr_reader :model, :record, :options

  def initialize(record, options = {})
    @model = record.class
    @record = record
    @options = options
  end

  def to_h
    hash = {MESSAGE_PACK_KEY => model.name}

    return hash.merge(id_attributes) if id_only?

    hash.merge! record.attributes
    reject_database_keys! hash if options.exclude_keys?
    reject_timestamps! hash if options.exclude_timestamps?
    discard_unsaved_changes! hash if options.exclude_unsaved_changes?

    hash
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

  def id_only?
    return false if record.new_record?
    return false if options.include_descendants?
    options.exclude_unsaved_changes?
  end

  def id_attributes
    {primary_key_name => record.attributes[primary_key_name]}
  end
end
