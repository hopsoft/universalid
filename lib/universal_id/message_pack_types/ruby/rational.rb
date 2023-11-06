# frozen_string_literal: true

UniversalID::MessagePackFactory.register_next_type Rational,
  packer: ->(obj, packer) { packer.write obj.to_s },
  unpacker: ->(unpacker) { Kernel.Rational unpacker.read },
  recursive: true
