# frozen_string_literal: true

UniversalID::MessagePackTypes.register Rational,
  # to_msgpack_ext
  packer: ->(rational) { MessagePack.pack rational.to_s },

  # from_msgpack_ext
  unpacker: ->(string) { Rational MessagePack.unpack(string) }
