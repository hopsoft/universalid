# frozen_string_literal: true

UniversalID::MessagePackFactory.register(
  type: Complex,
  recreate_pool: false,
  packer: ->(obj, packer) { packer.write obj.to_s },
  unpacker: ->(unpacker) { Kernel.Complex unpacker.read }
)
