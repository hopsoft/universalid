# frozen_string_literal: true

require "uri"

unless defined?(::URI::UID) || ::URI.scheme_list.include?("UID")

  module URI
    class UID < ::URI::Generic
      VERSION = UniversalID::VERSION
      SCHEME = "uid"
      HOST = "universalid"

      class << self
        def encoder
          UniversalID::Encoder
        end

        def fingerprint(object)
          encode fingerprint_components(object)
        end

        def parse(value)
          return nil if value.nil?
          return value if value.is_a?(self)

          value = value.to_s
          return nil if value.strip.empty?

          new(*::URI.split(value))
        end

        def build_string(payload, object = nil)
          "#{SCHEME}://#{HOST}/#{payload}##{fingerprint(object)}"
        end

        def build(object, options = {}, &block)
          path = "/#{encode(object, options, &block)}"
          parse "#{SCHEME}://#{HOST}#{path}##{fingerprint(object)}"
        end

        def from_payload(payload, object = nil)
          parse(build_string(payload, object)).tap do |uid|
            # NOTE: fingerprint mismatch can happen when building from a UID payload
            #       ensure the fingerprint is correct
            if uid&.valid? && URI::UID.fingerprint(uid.decode) != uid.fingerprint
              uid.instance_variable_set :@decoded_fingerprint, nil
              uid.instance_variable_set :@fragment, URI::UID.build(uid.decode).fingerprint
            end
          end
        end

        def encode(object, options = {})
          return yield(object, options) if block_given?
          encoder.encode object, options
        end

        def decode(...)
          encoder.decode(...)
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

        private

        def fingerprint_components(object)
          klass = object.is_a?(Class) ? object : object.class
          tokens = [klass]

          begin
            path = const_source_location(klass.name).first.to_s
            tokens << ::File.mtime(path).utc if ::File.exist?(path)
          rescue => e
            UniversalID.logger&.warn "URI::UID#fingerprint: Unable to determine the source location for #{klass.name}!\n#{e.message}}"
          end

          tokens
        end
      end

      def payload
        path[1..]
      end

      def fingerprint(decode: false)
        return @decoded_fingerprint ||= decode_fingerprint if decode
        fragment
      end

      def valid?
        case self
        in scheme: SCHEME, host: HOST, path: p, fragment: _ if p.size >= 8 then return true
        else false
        end
      end

      def invalid?
        !valid?
      end

      def decode(force: false)
        return nil unless valid?

        @decoded = nil if force
        return @decoded if defined?(@decoded)

        @decoded ||= yield(decode_payload, *decode_fingerprint) if block_given?
        @decoded ||= decode_payload
      end

      def deconstruct_keys(_keys)
        {scheme: scheme, host: host, path: path, fragment: fragment}
      end

      def inspect
        "#<URI::UID payload=#{payload.truncate 40}, fingerprint=#{fingerprint.truncate 40}>"
      end

      private

      def decode_payload
        self.class.decode payload
      end

      def decode_fingerprint
        self.class.decode fingerprint
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
