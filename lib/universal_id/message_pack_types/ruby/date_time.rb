# frozen_string_literal: true

::UniversalID::MessagePacker.register_type ::DateTime,
  packer: ->(obj, packer) { packer.write obj.iso8601(9) },
  unpacker: ->(unpacker) { ::DateTime.parse unpacker.read },
  recursive: true
