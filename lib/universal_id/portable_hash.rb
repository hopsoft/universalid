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
        next if include_list.any? && incldue_list.none?(key)
        next if exclude_list.any?(key)
        transform(value, options: options) { |val| memo[key] = val }
      end
    end

    private

    def transform(value, options:)
      value = case value
      when Hash then deep_transform(value, options)
      when Array then value.map { |val| transform(val, options: options) }
      else value
      end

      if block_given?
        yield value if value.present? || options[:allow_blank]
      end

      value
    end
  end

  delegate :config, to: :"self.class"

  def initialize(hash)
    options = hash.delete(:portable_hash_options) || {}
    options[:only] = Set.new(config[:only] + options[:only].to_a).to_a
    options[:except] = Set.new(config[:except] + options[:except].to_a).to_a
    merge! self.class.deep_transform(hash, options)
  end

  def id
    compressed_json = Zlib::Deflate.deflate(to_json, Zlib::BEST_COMPRESSION)
    Base64.urlsafe_encode64 compressed_json, padding: false
  end
end
