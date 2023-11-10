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

        def create(object, options = {})
          path = "/#{UniversalID::Encoder.encode(object, options)}"
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
        case self
        in scheme: SCHEME, host: HOST, path: p if p.size >= 8 then return true
        else false
        end
      end

      def invalid?
        !valid?
      end

      def decode
        UniversalID::Encoder.decode(payload) if valid?
      end

      def deconstruct_keys(_keys)
        {scheme: scheme, host: host, path: path}
      end

      def inspect
        "#<URI::UID scheme=#{scheme}, host=#{host}, path=#{(path.length > 40) ? "#{path[0..36]}..." : path}>"
      end

      if defined? GlobalID::Identification
        class GlobalIDRecord
          include GlobalID::Identification

          def self.find(value)
            new value
          end

          attr_reader :id, :uid

          def initialize(uid)
            uid = case uid.to_s
            when /\A#{URI::UID::SCHEME}/o then URI::UID.parse(uid)
            else URI::UID.build(scheme: URI::UID::SCHEME, host: URI::UID::HOST, path: "/#{uid}")
            end

            @uid = uid
            @id = uid&.payload
          end

          def uid
            URI::UID.build scheme: URI::UID::SCHEME, host: URI::UID::HOST, path: "/#{id}"
          end
        end

        class << self
          def from_global_id_record(gid_record)
            gid_record.find&.uid
          end

          def from_global_id(gid, options = {})
            from_global_id_record GlobalID.parse(gid, options)
          end

          alias_method :from_gid, :from_global_id

          def from_signed_global_id(sgid, options = {})
            from_global_id_record SignedGlobalID.parse(sgid, options)
          end

          alias_method :from_sgid, :from_signed_global_id
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
