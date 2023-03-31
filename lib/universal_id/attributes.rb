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
        new JSON.parse(Base64.decode64(id))
      end

      def deep_transform(hash = {})
        hash.each_with_object({}) do |(key, value), memo|
          memo[key.to_s] = BLOCK_LIST[key] ? nil : transform(value)
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

    def initialize(attributes = {})
      attributes = self.class.deep_transform(attributes)
      merge! attributes.compact
    end

    def id
      Base64.encode64 to_json
    end
  end
end
