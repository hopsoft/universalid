# frozen_string_literal: true

module UniversalID
  class Attributes < Hash
    include GlobalID::Identification

    DEFAULT_OPTIONS = {
      allow_blank: false,
      block_list: {
        id: true,
        created_at: true,
        updated_at: true
      }.with_indifferent_access.freeze
    }.with_indifferent_access.freeze

    class << self
      def find(id)
        compressed_json = Base64.urlsafe_decode64(id)
        JSON.parse Zlib::Inflate.inflate(compressed_json)
      end

      def deep_transform(hash = {})
        block_list = DEFAULT_OPTIONS[:block_list]
        hash.each_with_object({}) do |(key, value), memo|
          key = key.to_s
          next if block_list[key]
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

        yield value if value.present? || DEFAULT_OPTIONS[:allow_blank]
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
