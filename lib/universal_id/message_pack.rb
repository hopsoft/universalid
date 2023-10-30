# frozen_string_literal: true

require "msgpack"

# Ensure that pack/unpack preserves symbols
MessagePack::DefaultFactory.register_type(0, Symbol)

module UniversalID::MessagePack
  using UniversalID::Extensions::KernelRefinements
  class << self
    def next_type_id
      MessagePack::DefaultFactory.registered_types
        .map { |entry| entry[:type] }
        .max.to_i + 1
    end

    def register_type(...)
      MessagePack::DefaultFactory.register_type(next_type_id, ...)
    end

    # Prepares a generic payload for MessagePack.pack
    #
    # Handles the following object types:
    #
    # - Custom defined Structs
    #   * Struct.new(:foo, :bar).new(foo: "foo", bar: "bar")
    #   * MyStruct = Struct.new(:foo, :bar); MyStruct.new(foo: "foo", bar: "bar")
    #
    # - Objects that impelement the GlobalID::Identification interface and respond to #to_gid_param
    # - Any other objects that can be marshaled with Marshal.dump
    #
    # @param object [Object] The object to be packed
    # @return [String] The packed value
    def pack_generic_object(object)
      # the payload is an array that will be packed with MessagePack
      # [
      #   CLASS_NAME,
      #   DATA,
      #   EXTRA (optional, indicates if there is extra work to be done to unpack the object)
      # ]
      payload = case object
      when Struct then [object.class.name, object.to_h]
      when ->(o) { o.respond_to?(:to_gid_param) }
        gid = object.to_gid
        [gid.class.name, gid.to_param, true]
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

      nil if payload.nil?

      class_name, data, extra = payload
      klass = const_find(class_name)

      if klass.ancestors.include?(Struct)
        klass.new(**data)
      elsif klass == GlobalID
        gid = klass.parse(data)
        extra ? gid.find : gid
      else
        Marshal.load(data)
      end
    end
  end
end

path = File.join(File.dirname(__FILE__), "message_pack", "types", "**", "*.rb")
Dir.glob(path).each { |file| require file }
