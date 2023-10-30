# frozen_string_literal: true

UniversalID::MessagePack.register_type Time,
  # to_msgpack_ext
  packer: ->(time) { time.iso8601(9).b },

  # from_msgpack_ext
  unpacker: ->(string) { Time.parse string }
