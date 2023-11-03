# frozen_string_literal: true

::UniversalID::MessagePackFactory.register_next_type ::Time,
  packer: ->(obj, packer) { packer.write obj.iso8601(9) },
  unpacker: ->(unpacker) { ::Time.parse unpacker.read },
  recursive: true
