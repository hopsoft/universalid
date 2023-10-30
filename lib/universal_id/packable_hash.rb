# frozen_string_literal: true

require_relative "encodable_object"

# Provide UniversalID (UID) packing capabilities for Hashes
class UniversalID::PackableHash < UniversalID::EncodableObject
  class << self
    # Returns the configured default default pack options for UniversalID::PackableHash
    #
    # @return [HashWithIndifferentAccess] the default configuration
    def default_pack_options
      @config ||= UniversalID.config.dig(:packable_hash, :pack_options).tap do |c|
        c[:only] = (c[:only] || []).map(&:to_s)
        c[:except] = (c[:except] || []).map(&:to_s)
      end.with_indifferent_access
    end
  end

  delegate :default_pack_options, to: :"self.class"

  # Initializes a new instance of UniversalID::PackableHash
  #
  # @param hash [Hash] (default: {}) the Hash to wrap
  # @return [void]
  def initialize(hash = {})
    super hash.with_indifferent_access
  end

  # Packs the Hash into a compact URL safe String
  # Implicitly and recursively converts any values that impelment GlobalID::Identification
  #
  # @param options [Hash] the options to normalize and use for packing.
  # @option options [Boolean] (default: false) :allow_blank whether to allow blank values
  # @option options [Array] (default: []) :only keys to include (recursive, trumps except)
  # @option options [Array] (default: []) :except keys to exclude (recursive)
  # @return [UniversalID::PackableObject]
  def pack(options = {})
    super packable_value(object, normalize_options(options))
  end

  private

  def normalize_options(options = {})
    options ||= {}
    default_pack_options.merge(options).with_indifferent_access.tap do |opts|
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
    when Hash, UniversalID::PackableHash
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
