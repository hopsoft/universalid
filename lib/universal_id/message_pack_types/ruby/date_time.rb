# frozen_string_literal: true

UniversalID::MessagePackFactory.register_next_type DateTime,
  packer: ->(obj, packer) { packer.write obj.iso8601(9) },
  unpacker: ->(unpacker) { DateTime.parse unpacker.read },
  recursive: true
