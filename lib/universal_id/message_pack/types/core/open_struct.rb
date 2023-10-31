# frozen_string_literal: true

UniversalID::MessagePackUtils.register_type OpenStruct,
  # to_msgpack_ext
  packer: ->(open_struct) { open_struct.to_h.to_msgpack },

  # from_msgpack_ext
  unpacker: ->(string) { OpenStruct.new MessagePack.unpack(string) }
