# frozen_string_literal: true

module UniversalID
  class UID < URI::Generic
    using UniversalID::Extensions::ObjectRefinement
    using UniversalID::Extensions::StringRefinement

    class << self
      def parse(value)
        components = URI.split(value.to_s)
        new(*components)
      end

      def create(packable, app_name: UniversalID.app, pack_options: {})
        host = app_name.componentize
        path = "/#{packable.class.name.componentize}/#{packable.pack(pack_options)}"
        parse "uid://#{host}#{path}"
      end
    end

    def app_name
      host.to_s.decomponentize
    end

    def app
      Object.const_find app_name
    end

    def packable_class_name
      _, class_name, _ = path.split("/", 3)
      class_name.to_s.decomponentize
    end

    def packable_class
      Object.const_find packable_class_name
    end

    def payload
      _, _, value = path.split("/", 3)
      value.to_s
    end

    def unpackable?
      packable_class.respond_to?(:unpack) && payload.present?
    end

    def deconstruct_keys(_keys)
      {
        app_name: app_name,
        app: app,
        packable_class_name: packable_class_name,
        packable: packable,
        packed_value: packed_value
      }
    end
  end
end
