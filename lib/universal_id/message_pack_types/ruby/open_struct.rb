# frozen_string_literal: true

UniversalID::MessagePackFactory.register_next_type OpenStruct,
  packer: ->(obj, packer) { packer.write obj.to_h },
  unpacker: ->(unpacker) { OpenStruct.new unpacker.read },
  recursive: true
