# frozen_string_literal: true

require "bigdecimal"

UniversalID::MessagePackFactory.register_scalar(
  type: BigDecimal,
  recreate_pool: false,
  packer: ->(obj, packer) { packer.write obj.to_s },
  unpacker: ->(unpacker) { BigDecimal unpacker.read }
)
