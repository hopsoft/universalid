# frozen_string_literal: true

class UniversalID::MarshalableHash
  include UniversalID::Packable

  class << self
    # Returns the default default configuration for UniversalID::MarshalableHash
    #
    # @return [HashWithIndifferentAccess] the default configuration
    def config
      @config ||= UniversalID.config.dig(:marshalable_hash).with_indifferent_access
    end

    # Returns the default options for `to_packpackable`
    # These defaults can be overridden when calling `to_packable`
    #
    # @return [HashWithIndifferentAccess]
    def default_to_packable_options
      @default_to_packable_options ||= config.dig(:to_packable_options).tap do |c|
        c[:only] = (c[:only] || []).map(&:to_s)
        c[:except] = (c[:except] || []).map(&:to_s)
      end
    end
  end

  delegate :default_to_packable_options, to: :"self.class"
  delegate_missing_to :@hash

  # Initializes a new instance of UniversalID::MarshalableHash
  #
  # @param hash [Hash] (default: {}) the Hash to wrap
  # @return [void]
  def initialize(hash = {})
    @hash = hash.with_indifferent_access
  end

  # Converts the object to a UniversalID::MarshalableHash
  # Implicitly and recursively converts any values that impelment GlobalID::Identification
  #
  # @param options [Hash] the options to normalize and use for packing.
  # @option options [Boolean] (default: false) :allow_blank whether to allow blank values
  # @option options [Array] (default: []) :only keys to include (recursive, trumps except)
  # @option options [Array] (default: []) :except keys to exclude (recursive)
  # @return [UniversalID::PackableObject]
  def to_packable(options = {})
    UniversalID::PackableObject.new(
      packable_value(@hash, normalize_options(options)).deep_stringify_keys
    )
  end

  private

  def normalize_options(options = {})
    options ||= {}
    default_to_packable_options.merge(options).with_indifferent_access.tap do |opts|
      opts[:allow_blank] = !!opts[:allow_blank]
      %i[only except].each do |key|
        opts[key] ||= []
        opts[key] = [opts[key]].compact.flatten unless opts[key].is_a?(Array)
        opts[key] = opts[key].map(&:to_s)
      end
    end
  end

  def packable_value(value, options = {})
    case value
    when Array then value.map { |val| packable_value(val, options) }
    when Hash, UniversalID::MarshalableHash
      value.each_with_object({}) do |(key, val), memo|
        key = key.to_s
        next if options[:only].any? && options[:only].none?(key)
        next if options[:except].any?(key)
        val = packable_value(val, options)
        memo[key] = val if val.present? || options[:allow_blank]
      end
    else value
    end
  end
end
