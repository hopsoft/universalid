# frozen_string_literal: true

unless defined?(::URI::UID) || ::URI.scheme_list.include?("UID")

  module URI
    class UID < ::URI::Generic
      extend Forwardable

      SCHEME = "uid"
      HOST = "universal-id"

      class << self
        def parse(value)
          components = ::URI.split(value.to_s)
          new(*components)
        end

        alias_method :find, :parse

        def create(object)
          path = "/#{UniversalID::Encoder.encode(object)}"
          parse "#{SCHEME}://#{HOST}#{path}"
        end

        def new(...)
          super.tap do |uri|
            if uri.invalid?
              raise ::URI::InvalidURIError, "Scheme must be `#{SCHEME}`" if uri.scheme != SCHEME
              raise ::URI::InvalidURIError, "Host must be `#{HOST}`" if uri.host != HOST
              raise ::URI::InvalidURIError, "Unable to parse `payload`" if uri.payload.strip.empty?
            end
          end
        end
      end

      def payload
        path[1..]
      end

      def valid?
        scheme == SCHEME && host == HOST && !payload.strip.empty?
      end

      def invalid?
        !valid?
      end

      def decode
        UniversalID::Encoder.decode(payload) if valid?
      end

      if defined? ::GlobalID::Identification
        class GlobalIDRecord
          include ::GlobalID::Identification

          def self.find(value)
            new UID.parse(value)
          end

          attr_reader :id, :uid

          def initialize(uid)
            @uid = uid
            @id = uid.to_s
          end
        end

        # Returns a GlobalIDRecord instance which implements the GlobalID::Identification interface/protocol
        def to_global_id_record
          GlobalIDRecord.new self
        end

        # Adds all GlobalID::Identification methods to URI::UID
        def_delegators(:to_global_id_record, *GlobalID::Identification.instance_methods(false))
      end
    end

    # Register the URI scheme
    if ::URI.respond_to? :register_scheme
      ::URI.register_scheme "UID", UID unless ::URI.scheme_list.include?("UID")
    else
      # shenanigans to support Ruby 3.0.X
      ::URI::UID = UID unless defined?(::URI::UID)
      ::URI.scheme_list["UID"] = UID
    end
  end
end
