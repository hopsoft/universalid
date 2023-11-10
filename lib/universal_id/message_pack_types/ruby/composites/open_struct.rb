# frozen_string_literal: true

UniversalID::MessagePackFactory.register(
  type: OpenStruct,
  recreate_pool: false,
  packer: ->(obj, packer) { packer.write obj.to_h },
  unpacker: ->(unpacker) { OpenStruct.new unpacker.read }
)
