# frozen_string_literal: true

UniversalID::MessagePackFactory.register(
  type: Rational,
  recreate_pool: false,
  packer: ->(obj, packer) { packer.write obj.to_s },
  unpacker: ->(unpacker) { Kernel.Rational unpacker.read }
)
