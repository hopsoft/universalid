# frozen_string_literal: true

if defined? SignedGlobalID

  UniversalID::MessagePackFactory.register(
    type: SignedGlobalID,
    recreate_pool: false,
    packer: ->(obj, packer) { packer.write obj.to_param },
    unpacker: ->(unpacker) { ::SignedGlobalID.parse unpacker.read }
  )

end
