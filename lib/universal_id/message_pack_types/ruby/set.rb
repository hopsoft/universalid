# frozen_string_literal: true

::UniversalID::MessagePacker.register_type ::Set,
  packer: ->(obj, packer) { packer.write obj.to_a },
  unpacker: ->(unpacker) { ::Set.new unpacker.read },
  recursive: true
