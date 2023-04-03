# frozen_string_literal: true

class UniversalID::HashWithGID < Hash
  include GlobalID::Identification

  class << self
    def config
      UniversalID.config.hash_with_gid.with_indifferent_access
    end

    def find(id)
      compressed_json = Base64.urlsafe_decode64(id)
      JSON.parse Zlib::Inflate.inflate(compressed_json)
    rescue => error
      raise UniversalID::LocatorError.new(id, error)
    end

    def deep_transform(options:, **hash)
      allow_list = options[:allow_list]
      block_list = options[:block_list]
      hash.each_with_object({}) do |(key, value), memo|
        key = key.to_s
        next if allow_list.any? && allow_list.none?(key)
        next if block_list.any?(key)
        transform(value, options: options) { |val| memo[key] = val }
      end
    end

    private

    def transform(value, options:)
      value = case value
      when Hash then deep_transform(options: options, **value)
      when Array then value.map { |val| transform(val, options: options) }
      else value
      end

      if block_given?
        yield value if value.present? || options[:allow_blank]
      end

      value
    end
  end

  def initialize(hash_with_gid_options: {}, **hash)
    options = UniversalID::HashWithGID.config.merge(hash_with_gid_options)
    merge! self.class.deep_transform(options: options, **hash)
  end

  def id
    compressed_json = Zlib::Deflate.deflate(to_json, Zlib::BEST_COMPRESSION)
    Base64.urlsafe_encode64 compressed_json, padding: false
  end
end
