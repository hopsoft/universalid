# frozen_string_literal: true

UniversalID::MessagePackFactory.register_next_type Set,
  packer: ->(obj, packer) { packer.write obj.to_a },
  unpacker: ->(unpacker) { Set.new unpacker.read },
  recursive: true
