# frozen_string_literal: true

UniversalID::MessagePack.register_type SignedGlobalID,
  # to_msgpack_ext
  packer: ->(sgid) { sgid.to_param.b },

  # from_msgpack_ext
  unpacker: ->(string) { SignedGlobalID.parse string.encode(Encoding::UTF_8) }
