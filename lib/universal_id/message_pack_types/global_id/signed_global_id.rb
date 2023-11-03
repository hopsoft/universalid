# frozen_string_literal: true

if defined? ::SignedGlobalID

  ::UniversalID::MessagePackFactory.register_next_type ::SignedGlobalID,
    packer: ->(obj, packer) { packer.write obj.to_param },
    unpacker: ->(unpacker) { ::SignedGlobalID.parse unpacker.read },
    recursive: true

end
