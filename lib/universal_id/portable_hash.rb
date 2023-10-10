# frozen_string_literal: true

class UniversalID::PortableHash < Hash
  include UniversalID::Portable

  class << self
    def config
      super.portable_hash.with_indifferent_access
    end

    def find(id)
      compressed_json = Base64.urlsafe_decode64(id)
      JSON.parse Zlib::Inflate.inflate(compressed_json)
    rescue => error
      raise UniversalID::LocatorError.new(id, error)
    end

    def deep_transform(hash, options)
      include_list = options[:only]
      exclude_list = options[:except]
      hash.each_with_object({}) do |(key, value), memo|
        key = key.to_s
        next if include_list.any? && include_list.none?(key)
        next if exclude_list.any?(key)
        transform(value, options: options) { |val| memo[key] = val }
      end
    end

    private

    def transform(value, options:)
      value = case value
      when Hash then deep_transform(value, options)
      when Array then value.map { |val| transform(val, options: options) }
      else
        implements_gid?(value) ? value.to_gid.to_s : value
      end

      if block_given?
        yield value if value.present? || options[:allow_blank]
      end

      value
    end

    def implements_gid?(value)
      value.respond_to?(:to_gid_param) && value.try(:persisted?)
    end

    def possible_gid_string?(value)
      return false unless value.is_a?(String)
      GID_PARAM_REGEX.match? value
    end
  end

  delegate :config, to: :"self.class"
  attr_reader :options

  def initialize(hash)
    @options = merge_options!(extract_options!(hash))
    merge! self.class.deep_transform(hash, options)
  end

  def id
    compressed_json = Zlib::Deflate.deflate(to_json, Zlib::BEST_COMPRESSION)
    Base64.urlsafe_encode64 compressed_json, padding: false
  end

  private

  def extract_options!(hash)
    options = hash.delete(:portable_hash_options) || hash.delete("portable_hash_options") || {}
    options = options.each_with_object({}) do |(key, val), memo|
      memo[key.to_sym] = val.is_a?(Array) ? val.map(&:to_s) : val
    end
    options.with_indifferent_access
  end

  def merge_options!(options)
    config.each do |key, val|
      default = config[key]
      custom = options[key]

      if default.is_a?(Array)
        custom = [] if custom.nil?
        custom = custom.is_a?(Array) ? custom : [custom]
        options[key] = (default + custom).uniq
      else
        options[key] = custom || default
      end
    end

    options
  end
end
