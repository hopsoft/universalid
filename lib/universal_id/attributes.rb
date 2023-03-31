# frozen_string_literal: true

module UniversalID
  class Attributes < Hash
    include GlobalID::Identification

    BLOCK_LIST = {
      "id" => true,
      "created_at" => true,
      "updated_at" => true
    }.freeze

    class << self
      def find(id)
        compressed_json = Base64.urlsafe_decode64(id)
        JSON.parse Zlib::Inflate.inflate(compressed_json)
      end

      def deep_transform(hash = {})
        hash.each_with_object({}) do |(key, value), memo|
          key = key.to_s
          memo[key] = BLOCK_LIST[key] ? nil : transform(value)
        end
      end

      private

      def transform(value)
        case value
        when Hash then deep_transform(value)
        when Array then value.map { |val| transform(val) }
        else value.blank? ? nil : value
        end
      end
    end

    # TODO: support passing additional block list
    def initialize(attributes = {})
      attributes = self.class.deep_transform(attributes)
      merge! attributes.compact
    end

    def id
      compressed_json = Zlib::Deflate.deflate(to_json, Zlib::BEST_COMPRESSION)
      Base64.urlsafe_encode64 compressed_json, padding: false
    end
  end
end
