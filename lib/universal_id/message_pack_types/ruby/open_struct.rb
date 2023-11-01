# frozen_string_literal: true

UniversalID::MessagePackTypes.register OpenStruct,
  # to_msgpack_ext
  packer: ->(open_struct) { MessagePack.pack open_struct.to_h },

  # from_msgpack_ext
  unpacker: ->(string) { OpenStruct.new MessagePack.unpack(string) }
