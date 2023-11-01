# frozen_string_literal: true

::UniversalID::MessagePackTypes.register ::UniversalID::URI::UID,
  # to_msgpack_ext
  packer: ->(uid) { ::MessagePack.pack uid.to_s },

  # from_msgpack_ext
  unpacker: ->(string) { ::UniversalID::URI::UID.parse ::MessagePack.unpack(string) }
