# frozen_string_literal: true

# Fallback / catch-all for anything not already covered by another registered type
#
UniversalID::MessagePack.register_type Object,
  # to_msgpack_ext
  packer: UniversalID::MessagePack.method(:pack_generic_object),

  # from_msgpack_ext
  unpacker: UniversalID::MessagePack.method(:unpack_generic_object)
