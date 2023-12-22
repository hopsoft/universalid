# frozen_string_literal: true

require "date"

UniversalID::MessagePackFactory.register_scalar(
  type: DateTime,
  recreate_pool: false,
  packer: ->(obj, packer) { packer.write obj.iso8601(9) },
  unpacker: ->(unpacker) { DateTime.parse unpacker.read }
)
