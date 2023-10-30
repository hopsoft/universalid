# frozen_string_literal: true

using UniversalID::Extensions::KernelRefinements

# Fallback / catch-all for anything not already covered by another registered type
#
# Also, handles Structs and Custom defined Structs
# - Struct.new(:foo, :bar).new(foo: "foo", bar: "bar")
# - MyStruct = Struct.new(:foo, :bar); MyStruct.new(foo: "foo", bar: "bar")
#
# NOTE: Comment this logic if you want to test the other registered types in isolation
# NOTE: Ojects that can't be marshaled will return nil
#
UniversalID::MessagePack.register_type Object,
  # to_msgpack_ext
  packer: ->(object) do
    begin
      case object
      when Struct
        MessagePack.pack [
          object.class.name, # class name
          object.to_h        # data
        ]
      else
        MessagePack.pack [
          object.class.name,   # class name
          Marshal.dump(object) # data
        ]
      end
    rescue
      MessagePack.pack nil
    end
  end,

  # from_msgpack_ext
  unpacker: ->(string) do
    payload = MessagePack.unpack(string)

    if payload.nil?
      nil
    else
      class_name = payload.first
      data = payload.last

      klass = const_find(class_name)
      if klass.ancestors.include?(Struct)
        klass.new(**data)
      else
        Marshal.load data
      end
    end
  end
