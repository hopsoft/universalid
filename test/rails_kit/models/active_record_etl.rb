# frozen_string_literal: true

class ActiveRecordETL
  class << self
    # Parses a ActiveRecordETL transformed payload in the specified format
    #
    # @param payload [String] The tranformed payload to parse
    # @param :format [Symbol] The data format to transform the record into (optional, defaults to :json)
    # @return [Object] the parsed payload
    # @raise [NotImplementedError] if the specified format is not supported
    def parse(payload, format: :json)
      case format
      # when :json then JSON.parse payload
      when :json then Oj.load payload
      else raise NotImplementedError
      end
    end
  end

  # Initializes a new ActiveRecord ETL Data Pipeline
  # @param record [ActiveRecord] the record to ETL
  def initialize(record)
    @record = record
  end

  # The wrapped ActiveRecord instance
  attr_reader :record

  # The record's attributes
  #
  # @return [Hash] the record's attributes
  def attributes
    record.attributes
  end

  # Returns a list of all the record's associations
  #
  # @param :macro [String, Symbol] (:belongs_to, :has_many, ... optional, defaults to nil)
  # @return [Array<ActiveRecord::Reflection::AssociationReflection>]
  def associations(macro: nil)
    list = record.class.reflect_on_all_associations
    list = list.select { |a| a.macro == macro.to_sym } if macro
    list
  end

  # Returns a the record's loaded associations by name
  #
  # @param :macro [String] (:belongs_to, :has_many, ... optional, defaults to nil)
  # @return [Hash{String => ActiveRecord::Associations::CollectionProxy}]
  def loaded_associations_by_name(macro: nil)
    associations(macro: macro).each_with_object({}) do |association, memo|
      collection_proxy = record.public_send(association.name)
      memo[association.name.to_s] = collection_proxy if collection_proxy.loaded?
    end
  end

  # Returns the record's loaded `has_many` associations by name
  #
  # @return [Hash{String => ActiveRecord::Associations::CollectionProxy}]
  def loaded_has_many_associations_by_name
    loaded_associations_by_name macro: :has_many
  end

  # The record's primary key name
  #
  # @return [String]
  def primary_key
    record.class.primary_key
  end

  # Attribute names that the record `accepts_nested_attributes_for`
  #
  # @return [Array<String>]
  def nested_attribute_names
    record.class.nested_attributes_options.keys.map(&:to_s)
  end

  # Attribute names that the record `accepts_nested_attributes_for` that have been loaded into memory
  #
  # @return [Array<String>]
  def loaded_nested_attribute_names
    nested_attribute_names & loaded_has_many_associations_by_name.keys
  end

  # Attribute names for all the record's `belongs_to` associations
  #
  # @return [Array<String>]
  def parent_attribute_names
    record.class.reflections.each_with_object([]) do |(name, reflection), memo|
      memo << reflection.foreign_key if reflection.macro == :belongs_to
    end
  end

  # Attribute names for the record's timestamps
  #
  # @return [Array<String>]
  def timestamp_attribute_names
    record.class.all_timestamp_attributes_in_model
  end

  # Extracts data from the record
  #
  # @param :except [Array<String, Symbol>] List of attributes to omit (optional, trumps :only, defaults to [])
  # @param :only [Array<String, Symbol>] List of attributes to extract (optional, defaults to [])
  # @param :copy [Boolean] Whether or not to omit keys and timestamps (optional, defaults to false)
  # @param :nested_attributes [Boolean] Indicates if nested attributes should be included (optional, defaults to false)
  # @param :reject_blank [Boolean] Indicates if blank values should be omitted (optional, defaults to false)
  # @return [Hash{String => Object}] The extracted data
  def extract(**options)
    options = normalize_options(**options)

    hash = attributes.each_with_object({}) do |(name, value), memo|
      memo[name] = value unless skip?(name, value, **options)
    end

    if options[:nested_attributes]
      loaded_nested_attribute_names.each do |name|
        key = "#{name}_attributes"
        values = record.send(name)
        hash[key] = values.map { |val| extract_next(val, **options) } unless skip?(name, values, **options)
      end
    end

    hash
  end

  # Transforms the record into the specified data format
  #
  # @param :format [Symbol] The data format to transform the record into (optional, defaults to :json)
  # @param :except [Array<String, Symbol>] List of attributes to omit (optional, trumps :only, defaults to [])
  # @param :only [Array<String, Symbol>] List of attributes to extract (optional, defaults to [])
  # @param :copy [Boolean] Whether or not to omit keys and timestamps (optional, defaults to false)
  # @param :nested_attributes [Boolean] Indicates if nested attributes should be included (optional, defaults to false)
  # @param :reject_blank [Boolean] Indicates if blank values should be omitted (optional, defaults to false)
  # @return [String] the transformed data
  # @raise [NotImplementedError] if the specified format is not supported
  def transform(format: :json, **options)
    case format
    # when :json then extract(**options).to_json
    when :json then Oj.dump extract(**options), symbol_keys: false
    else raise NotImplementedError
    end
  end

  private

  def extract_next(record, **options)
    self.class.new(record).extract(**options)
  end

  def normalize_only_values(**options)
    (options[:only] || []).map(&:to_s)
  end

  def normalize_except_values(**options)
    (options[:except] || []).map(&:to_s).tap do |except|
      if options[:copy]
        except << primary_key
        except.concat parent_attribute_names, timestamp_attribute_names
      end
    end
  end

  def normalize_options(**options)
    options[:only] = normalize_only_values(**options)
    options[:except] = normalize_except_values(**options)
    options
  end

  def skip?(name, value, **options)
    name = name.to_s
    return true if options[:except].any? && options[:except].include?(name)
    return true if options[:only].any? && options[:only].exclude?(name)
    return true if value.blank? && options[:reject_blank]
    false
  end
end
