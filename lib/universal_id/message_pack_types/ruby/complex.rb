# frozen_string_literal: true

UniversalID::MessagePackFactory.register_next_type Complex,
  packer: ->(obj, packer) { packer.write obj.to_s },
  unpacker: ->(unpacker) { Kernel.Complex unpacker.read },
  recursive: true
