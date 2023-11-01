# frozen_string_literal: true

::UniversalID::MessagePackTypes.register ::Time,
  # to_msgpack_ext
  packer: ->(time) { ::MessagePack.pack time.iso8601(9) },

  # from_msgpack_ext
  unpacker: ->(string) { ::Time.parse ::MessagePack.unpack(string) }
