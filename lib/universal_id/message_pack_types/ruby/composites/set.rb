# frozen_string_literal: true

UniversalID::MessagePackFactory.register(
  type: Set,
  recusive: true,
  recreate_pool: false,
  packer: ->(obj, packer) { packer.write obj.to_a },
  unpacker: ->(unpacker) { Set.new unpacker.read }
)
