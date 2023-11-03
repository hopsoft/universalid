# frozen_string_literal: true

::UniversalID::MessagePacker.register_type ::Date,
  packer: ->(obj, packer) { packer.write obj.iso8601 },
  unpacker: ->(unpacker) { ::Date.parse unpacker.read },
  recursive: true
