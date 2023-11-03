# frozen_string_literal: true

if defined? ::SignedGlobalID

  ::UniversalID::MessagePacker.register_type ::SignedGlobalID,
    packer: ->(obj, packer) { packer.write obj.to_param },
    unpacker: ->(unpacker) { ::SignedGlobalID.parse unpacker.read },
    recursive: true

end
