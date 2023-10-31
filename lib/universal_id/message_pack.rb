# frozen_string_literal: true

# Ensure that pack/unpack preserves symbols
MessagePack::DefaultFactory.register_type(0, Symbol)

module UniversalID::MessagePack
  using UniversalID::Extensions::KernelRefinements

  class TypeIDError < StandardError; end

  class << self
    def next_type_id
      id = 0
      id += 1 while id <= 127 && MessagePack::DefaultFactory.type_registered?(id)
      id
    end

    def register_type(...)
      id = next_type_id
      raise TypeIDError, "Unable to register MessagePack Type with id: #{id}" if MessagePack::DefaultFactory.type_registered?(id)
      MessagePack::DefaultFactory.register_type(id, ...)
    end

    # TODO: add support for individual type registration
    def register_all_types!
      path = File.join(File.dirname(__FILE__), "message_pack", "types", "**", "*.rb")
      Dir.glob(path).each { |file| require file }
    end

    # Prepares a generic payload for MessagePack.pack
    #
    # Handles the following object types:
    #
    # - Custom defined Structs
    #   * Struct.new(:foo, :bar).new(foo: "foo", bar: "bar")
    #   * MyStruct = Struct.new(:foo, :bar); MyStruct.new(foo: "foo", bar: "bar")
    #
    # - Objects that impelement the GlobalID::Identification interface (i.e. respond to #to_global_id)
    # - Any other objects that can be marshaled with Marshal.dump
    #
    # @param object [Object] The object to be packed
    # @return [String] The packed value
    def pack_generic_object(object)
      # the payload is an array that will be packed with MessagePack
      # [
      #   CLASS_NAME,
      #   DATA
      # ]
      payload = case object
      when Struct then [object.class.name, object.to_h]
      when ->(o) { o.respond_to?(:to_global_id) }
        if object.persisted?
          gid = object.to_global_id
          [gid.class.name, gid.to_param, true]
        else
          [object.class.name, object.as_json.compact]
        end
      else [object.class.name, Marshal.dump(object)]
      end
      MessagePack.pack payload
    rescue
      MessagePack.pack nil
    end

    # Unpacks a generic payload Created by #pack_generic_object
    #
    # @param string [String] The packed value
    # @return [Object, nil] The unpacked object
    def unpack_generic_object(string)
      payload = MessagePack.unpack(string)
      return nil if payload.nil?

      class_name, data = payload
      klass = const_find(class_name)

      case klass
      when ->(k) { k.descends_from? Struct }
        # shenanigans to support Ruby 3.0.X and 3.1.X
        RUBY_VERSION.start_with?("3.0", "3.1") ?
          klass.new.tap { |struct| data.each { |key, val| struct[key] = data[key] } } :
          klass.new(**data)
      when ->(k) { k.descends_from? GlobalID, SignedGlobalID } then klass.parse(data)&.find
      when ->(k) { k.descends_from? ActiveRecord::Base } then klass.new(data)
      else Marshal.load(data)
      end
    end
  end
end
