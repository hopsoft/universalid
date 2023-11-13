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

        def build_string(payload)
          "#{SCHEME}://#{HOST}/#{payload}"
        end

        def build(object, options = {})
          path = "/#{UniversalID::Encoder.encode(object, options)}"
          parse "#{SCHEME}://#{HOST}#{path}"
        end

        # Creates a new URI::UID with the given URI components.
        # SEE: https://ruby-doc.org/3.2.2/stdlibs/uri/URI/Generic.html#method-c-new
        #
        # @param scheme [String] the scheme component.
        # @param userinfo [String] the userinfo component.
        # @param host [String] the host component.
        # @param port [Integer] the port component.
        # @param registry [String] the registry component.
        # @param path [String] the path component.
        # @param opaque [String] the opaque component.
        # @param query [String] the query component.
        # @param fragment [String] the fragment component.
        # @param parser [URI::Parser] the parser to use for the URI, defaults to DEFAULT_PARSER.
        # @param arg_check [Boolean] whether to check arguments, defaults to false.
        # @return [URI::UID] the new URI::UID instance.
        # # @raise [URI::InvalidURIError] if the URI is malformed.
        # @raise [ArgumentError] if the number of arguments is incorrect or an argument is of the wrong type.
        # @raise [TypeError] if an argument is not of the expected type.
        # @raise [URI::InvalidComponentError] if a component of the URI is not valid.
        # @raise [URI::BadURIError] if the URI is in a bad or unexpected state.
        def new(...)
          super.tap do |uri|
            if uri.invalid?
              raise ::URI::InvalidComponentError, "Scheme must be `#{SCHEME}`" if uri.scheme != SCHEME
              raise ::URI::InvalidComponentError, "Host must be `#{HOST}`" if uri.host != HOST
              raise ::URI::InvalidComponentError, "Unable to parse `payload` from the path component!" if uri.payload.strip.empty?
            end
          end
        end
      end

      def payload(truncate: false)
        (truncate && path.length > 80) ? "#{path[1..77]}..." : path[1..]
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
        "#<URI::UID scheme=#{scheme}, host=#{host}, payload=#{payload truncate: true}>"
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
