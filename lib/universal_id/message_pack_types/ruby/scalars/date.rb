# frozen_string_literal: true

UniversalID::MessagePackFactory.register_scalar(
  type: Date,
  recreate_pool: false,
  packer: ->(obj, packer) { packer.write obj.iso8601 },
  unpacker: ->(unpacker) { Date.parse unpacker.read }
)
