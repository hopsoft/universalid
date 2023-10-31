# frozen_string_literal: true

UniversalID::MessagePack.register_type UniversalID::URI::UID,
  # to_msgpack_ext
  packer: ->(uid) { uid.to_s.b },

  # from_msgpack_ext
  unpacker: ->(string) { UniversalID::URI::UID.parse string.encode(Encoding::UTF_8) }
