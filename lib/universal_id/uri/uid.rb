# frozen_string_literal: true

module UniversalID::URI
  class UID < URI::Generic
    using UniversalID::Refinements::Kernel
    using UniversalID::Refinements::String

    class GlobalIDRecord
      include ::GlobalID::Identification

      def self.find(value)
        new UniversalID::URI::UID.parse(value)
      end

      attr_reader :id, :uid

      def initialize(uid)
        @uid = uid
        @id = uid.to_s
      end
    end

    class << self
      def parse(value)
        components = URI.split(value.to_s)
        new(*components)
      end

      alias_method :find, :parse

      def create(object, options = UniversalID.config[:encode])
        host = UniversalID.app.hostify
        path = "/#{UniversalID::Encoder.encode(object, options)}"
        parse "uid://#{host}#{path}"
      end

      def new(...)
        super.tap do |uri|
          if uri.invalid?
            raise URI::InvalidURIError, "Scheme must be `uid`" if uri.scheme != "uid"
            raise URI::InvalidURIError, "Unable to parse `app_name`" if uri.app_name.blank?
            raise URI::InvalidURIError, "Unable to parse `payload`" if uri.payload.blank?
          end
        end
      end
    end

    def app_name
      host.to_s.dehostify
    end

    def app
      const_find app_name
    end

    def payload
      path[1..]
    end

    def decodable?
      app && payload.present?
    end

    def decode
      UniversalID::Encoder.decode(payload) if decodable?
    end

    def valid?
      scheme == "uid" && app_name.present? && payload.present?
    end

    def invalid?
      !valid?
    end

    # Returns a GlobalIDRecord instance which implements the GlobalID::Identification interface/protocol
    def to_global_id_record
      GlobalIDRecord.new self
    end

    # Adds all GlobalID::Identification methods to UniversalID::URI::UID
    delegate(*GlobalID::Identification.instance_methods(false), to: :to_global_id_record)

    def deconstruct_keys(_keys)
      {
        app: app,
        payload: payload
      }
    end
  end
end
