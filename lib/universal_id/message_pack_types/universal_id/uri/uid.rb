# frozen_string_literal: true

::UniversalID::MessagePacker.register_type ::UniversalID::URI::UID,
  packer: ->(obj, packer) { packer.write obj.to_s },
  unpacker: ->(unpacker) { ::UniversalID::URI::UID.parse unpacker.read },
  recursive: true
