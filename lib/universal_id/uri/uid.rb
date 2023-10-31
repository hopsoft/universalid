# frozen_string_literal: true

module UniversalID::URI
  class UID < URI::Generic
    using UniversalID::Extensions::KernelRefinements
    using UniversalID::Extensions::StringRefinements

    include GlobalID::Identification

    class << self
      def parse(value)
        components = URI.split(value.to_s)
        new(*components)
      end

      alias_method :find, :parse

      def create(object)
        host = UniversalID.app.hostify
        path = "/#{UniversalID::Encoder.encode(object)}"
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

    alias_method :id, :to_s

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

    def deconstruct_keys(_keys)
      {
        app: app,
        payload: payload
      }
    end
  end
end
