# frozen_string_literal: true

class UniversalID::PackableHash
  include UniversalID::Packable

  class << self
    # Returns the default configuration for UniversalID::PackableHash
    # Ensures that the keys of the hash can be accessed both as strings and symbols
    #
    # @return [HashWithIndifferentAccess] the configuration
    def config
      @config ||= super[:packable_hash].with_indifferent_access.tap do |c|
        c[:only] = (c[:only] || []).map(&:to_s)
        c[:except] = (c[:except] || []).map(&:to_s)
      end
    end

    # Finds a UniversalID::PackableHash record by it's ID
    #
    # @param id [UniversalID::Packable, GlobalID, SignedGlobalID, String] the ID to find
    # @return [UniversalID::Packable, nil] the found UniversalID object or nil if no object was found.
    # @raise [UniversalID::LocatorError] if the id cannot be found
    def find(id)
      new super
    end
  end

  delegate_missing_to :@hash

  # Initializes a new instance of UniversalID::PackableHash
  #
  # @param hash [Hash] (default: {}) the Hash to wrap
  # @return [void]
  def initialize(hash = {})
    @hash = hash.with_indifferent_access
  end

  # Converts the object to a UniversalID::PackableHash
  # Implicitly and recursively converts any values that impelment GlobalID::Identification
  #
  # @param options [Hash] the options to normalize and use for packing.
  # @option options [Boolean] (default: false) :allow_blank whether to allow blank values
  # @option options [Array] (default: []) :only keys to include (recursive, trumps except)
  # @option options [Array] (default: []) :except keys to exclude (recursive)
  # @return [UniversalID::PackableHash]
  def to_packable(**options)
    options = normalize_options(**options)
    packable_value(self, **options).deep_stringify_keys
  end

  private

  def normalize_options(**options)
    config.merge(options).tap do |opts|
      opts[:allow_blank] = !!opts[:allow_blank]
      %i[only except].each do |key|
        opts[key] ||= []
        opts[key] = [opts[key]].compact.flatten unless opts[key].is_a?(Array)
        opts[key] = opts[key].map(&:to_s)
      end
    end
  end

  def packable_value(value, **options)
    options = options.with_indifferent_access # TODO: Remove this line after we stop supporting Ruby 2.7
    case value
    when Array then value.map { |val| packable_value(val, **options) }
    when Hash, UniversalID::PackableHash
      value.each_with_object({}) do |(key, val), memo|
        key = key.to_s
        next if options[:only].any? && options[:only].none?(key)
        next if options[:except].any?(key)
        val = packable_value(val, **options)
        memo[key] = val if val.present? || options[:allow_blank]
      end
    else value
    end
  end
end
