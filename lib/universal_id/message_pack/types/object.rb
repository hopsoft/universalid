# frozen_string_literal: true

# This is where we register msgpack support for all Object types
#
# Reference:
#
#   MessagePack::Factory.register_type(
#    # an Integer that identifies the type entry in MessagePack's registry
#    type, # an Integer that identifies the type entry in MessagePack's registry
#
#    # the Ruby class we're registering and extension for
#    class,
#
#    options = {
#        # customizes how instances of the class are packed i.e. marshaled/serialized
#        packer: :to_msgpack_ext,
#
#        # customizes how instances of the class are unpacked i.e. unmarshaled/deserialized
#        unpacker: :from_msgpack_ext
#      }
#    )
#
UniversalID::MessagePack.register_type Object,
  # to_msgpack_ext
  packer: ->(object) do
    ## if value.respond_to? :to_gid_param
    ## value.to_gid_param.b
    # if object.respond_to? :to_msgpack_ext
    #  object.to_msgpack_ext
    # else
    #  object.to_msgpack # NOTE: triggers a recursive call
    # end

    # fallback/defalut default behavior
    MessagePack.pack Marshal.dump(object)
  end,

  # from_msgpack_ext
  unpacker: ->(string) do
    ## value = value.encode("UTF-8")

    ## gid = if UniversalID.possible_gid_string?(value)
    ## GlobalID.parse(value) || SignedGlobalID.parse(value)
    ## end

    ## gid ? gid.find : MessagePack.unpack(value)

    # if object.respond_to? :from_msgpack_ext
    #  object.from_msgpack_ext
    # else
    #  binding.pry
    # end

    Marshal.load MessagePack.unpack(string)
  end
