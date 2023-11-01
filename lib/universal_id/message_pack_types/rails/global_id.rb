# frozen_string_literal: true

UniversalID::MessagePackTypes.register GlobalID,
  # to_msgpack_ext
  packer: ->(gid) { MessagePack.pack gid.to_param },

  # from_msgpack_ext
  unpacker: ->(string) { GlobalID.parse MessagePack.unpack(string) }
