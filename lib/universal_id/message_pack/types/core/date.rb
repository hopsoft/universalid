# frozen_string_literal: true

UniversalID::MessagePack.register_type Date,
  # to_msgpack_ext
  packer: ->(date) { date.iso8601.b },

  # from_msgpack_ext
  unpacker: ->(string) { Date.parse string }
