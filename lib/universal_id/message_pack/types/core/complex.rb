# frozen_string_literal: true

UniversalID::MessagePack.register_type Complex,
  # to_msgpack_ext
  packer: ->(complex) { complex.to_s.b },

  # from_msgpack_ext
  unpacker: ->(string) { Complex string }
