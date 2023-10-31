# frozen_string_literal: true

UniversalID::MessagePackUtils.register_type Complex,
  # to_msgpack_ext
  packer: ->(complex) { complex.to_s.b },

  # from_msgpack_ext
  unpacker: ->(string) { Complex string }
