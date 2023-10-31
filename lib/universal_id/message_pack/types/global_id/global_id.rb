# frozen_string_literal: true

UniversalID::MessagePackUtils.register_type GlobalID,
  # to_msgpack_ext
  packer: ->(gid) { gid.to_param.b },

  # from_msgpack_ext
  unpacker: ->(string) { GlobalID.parse string.encode(Encoding::UTF_8) }
