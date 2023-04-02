# frozen_string_literal: true

module UniversalID
  class Attributes < Hash
    include GlobalID::Identification

    class << self
      def config
        UniversalID.config.attributes
      end

      def find(id)
        compressed_json = Base64.urlsafe_decode64(id)
        JSON.parse Zlib::Inflate.inflate(compressed_json)
      rescue => error
        raise UniversalID::LocatorError.new(id, error)
      end

      def deep_transform(hash = {})
        allow_list = config[:allow_list]
        block_list = config[:block_list]
        hash.each_with_object({}) do |(key, value), memo|
          key = key.to_s
          next if allow_list&.none?(key)
          next if block_list&.any?(key)
          transform(value) { |val| memo[key] = val }
        end
      end

      private

      def transform(value)
        case value
        when Hash then deep_transform(value)
        when Array then value.map { |val| transform(val) }
        else value
        end

        yield value if value.present? || config[:allow_blank]
        value
      end
    end

    # TODO: support passing option overrides
    def initialize(attributes = {})
      merge! self.class.deep_transform(attributes)
    end

    def id
      compressed_json = Zlib::Deflate.deflate(to_json, Zlib::BEST_COMPRESSION)
      Base64.urlsafe_encode64 compressed_json, padding: false
    end
  end
end
