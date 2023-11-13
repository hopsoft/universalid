# frozen_string_literal: true

UniversalID::MessagePackFactory.register(
  type: URI::UID,
  recreate_pool: false,
  packer: ->(obj, packer) { packer.write obj.to_s },
  unpacker: ->(unpacker) { URI::UID.parse unpacker.read }
)
