# frozen_string_literal: true

# This is where we register msgpack support for all Time instances
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
UniversalID::MessagePack.register_type Time,
  # to_msgpack_ext
  packer: ->(time) { time.iso8601(9).b },

  # from_msgpack_ext
  unpacker: ->(time) { Time.parse time.encode("UTF-8") }
