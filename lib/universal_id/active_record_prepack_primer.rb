# frozen_string_literal: true

# prepack: &prepack
#   [x] exclude: []
#   [x] include: []
#   [x] include_blank: true
#
#   active_record:
#     <<: *prepack
#     [x] exclude_database_keys: false
#     [x] exclude_timestamps: false
#     [x] include_unsaved_changes: false
#     [ ] include_loaded_associations: false # TODO: Implement this!
#     [ ] max_association_depth: 0 # TODO: Implement this!
class UniversalID::ActiveRecordPrepackPrimer
  MESSAGE_PACK_KEY = Digest::SHA1.hexdigest(name)[0, 8]

  attr_reader :model, :record, :options

  def initialize(record, options = UniversalID::Settings.default.prepack)
    @model = record.class
    @record = record
    @options = options
  end

  def to_h
    hash = {MESSAGE_PACK_KEY => model.name}

    return hash.merge(id_attributes) if id_only?

    hash.merge! record.attributes
    discard_database_keys! hash if exclude_database_keys?
    discard_timestamps! hash if exclude_timestamps?
    discard_unsaved_changes! hash if exclude_unsaved_changes?

    hash
  end

  private

  # config helpers ...........................................................................................
  def exclude_database_keys?
    !!options.active_record.exclude_database_keys
  end

  def exclude_timestamps?
    !!options.active_record.exclude_timestamps
  end

  def include_unsaved_changes?
    return true if record.new_record?
    !!options.active_record.include_unsaved_changes
  end

  def exclude_unsaved_changes?
    !include_unsaved_changes?
  end

  def include_loaded_associations?
    !!options.active_record.include_loaded_associations
  end

  def exclude_loaded_associations?
    !include_loaded_associations?
  end

  def max_association_depth
    options.active_record.max_association_depth.to_i
  end

  # attribute mutators .......................................................................................

  def discard_database_keys!(hash)
    hash.delete primary_key_name
    foreign_key_column_names.each { |key| hash.delete key }
  end

  def discard_timestamps!(hash)
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
    return false if include_loaded_associations?
    exclude_unsaved_changes?
  end

  def id_attributes
    {primary_key_name => record.attributes[primary_key_name]}
  end
end
