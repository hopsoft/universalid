# frozen_string_literal: true

::UniversalID::MessagePackFactory.register_next_type ::URI::UID,
  packer: ->(obj, packer) { packer.write obj.to_s },
  unpacker: ->(unpacker) { ::URI::UID.parse unpacker.read },
  recursive: true
