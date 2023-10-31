# frozen_string_literal: true

# Fallback / catch-all for anything not already covered by another registered type
#
UniversalID::MessagePackUtils.register_type Object,
  # to_msgpack_ext
  packer: UniversalID::MessagePackUtils.method(:pack_generic_object),

  # from_msgpack_ext
  unpacker: UniversalID::MessagePackUtils.method(:unpack_generic_object)
