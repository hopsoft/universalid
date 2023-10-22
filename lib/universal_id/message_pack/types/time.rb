# frozen_string_literal: true

UniversalID::MessagePack.register_type Time,
  packer: ->(value) { value.iso8601(9).b },
  unpacker: ->(value) { Time.parse value.encode("UTF-8") }
