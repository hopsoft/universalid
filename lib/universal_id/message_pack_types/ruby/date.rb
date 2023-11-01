# frozen_string_literal: true

::UniversalID::MessagePackTypes.register ::Date,
  # to_msgpack_ext
  packer: ->(date) { ::MessagePack.pack date.iso8601 },

  # from_msgpack_ext
  unpacker: ->(string) { ::Date.parse ::MessagePack.unpack(string) }
