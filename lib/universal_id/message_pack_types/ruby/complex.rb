# frozen_string_literal: true

UniversalID::MessagePackTypes.register Complex,
  # to_msgpack_ext
  packer: ->(complex) { MessagePack.pack complex.to_s },

  # from_msgpack_ext
  unpacker: ->(string) { Complex MessagePack.unpack(string) }
