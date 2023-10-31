# frozen_string_literal: true

UniversalID::MessagePackUtils.register_type Rational,
  # to_msgpack_ext
  packer: ->(rational) { rational.to_s.b },

  # from_msgpack_ext
  unpacker: ->(string) { Rational(string) }
