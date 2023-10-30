# frozen_string_literal: true

UniversalID::MessagePack.register_type DateTime,
  # to_msgpack_ext
  packer: ->(time) { time.iso8601(9).b },

  # from_msgpack_ext
  unpacker: ->(string) { DateTime.parse string }
