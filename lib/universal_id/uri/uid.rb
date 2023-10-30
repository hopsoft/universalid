# frozen_string_literal: true

module UniversalID::URI
  class UID < URI::Generic
    using UniversalID::Extensions::KernelRefinements
    using UniversalID::Extensions::StringRefinements

    class << self
      def parse(value)
        components = URI.split(value.to_s)
        new(*components)
      end

      def create(packable, options = {})
        host = UniversalID.app.componentize
        path = "/#{packable.pack(options)}"
        parse "uid://#{host}#{path}"
      end

      def new(...)
        super.tap do |uri|
          if uri.invalid?
            raise URI::InvalidURIError, "Scheme must be `uid`" if uri.scheme != "uid"
            raise URI::InvalidURIError, "Unable to parse `app_name`" if uri.app_name.blank?
            raise URI::InvalidURIError, "Unable to parse `package`" if uri.package.blank?
          end
        end
      end

      def match?(value)
        value.to_s.start_with? "uid://"
      end
    end

    def app_name
      host.to_s.decomponentize
    end

    def app
      const_find app_name
    end

    def package
      path[1..]
    end

    # Indicates if the package can be unpacked or opened (also aliased as `openable?`)
    # @return [Boolean]
    def unpackable?
      app && package.present?
    end

    # Indicates if the package can be unpacked or opened (alias for `unpackable?`)
    # @return [Boolean]
    alias_method :openable?, :unpackable?

    def valid?
      scheme == "uid" && app_name.present? && package.present?
    end

    def invalid?
      !valid?
    end

    def deconstruct_keys(_keys)
      {
        app: app,
        package: package
      }
    end
  end
end
