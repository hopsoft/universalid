# frozen_string_literal: true

UniversalID::MessagePackTypes.register SignedGlobalID,
  # to_msgpack_ext
  packer: ->(sgid) { MessagePack.pack sgid.to_param },

  # from_msgpack_ext
  unpacker: ->(string) { SignedGlobalID.parse MessagePack.unpack(string) }
