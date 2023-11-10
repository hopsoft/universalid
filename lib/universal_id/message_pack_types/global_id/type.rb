# frozen_string_literal: true

if defined? GlobalID

  UniversalID::MessagePackFactory.register(
    type: GlobalID,
    recreate_pool: false,
    packer: ->(obj, packer) { packer.write obj.to_param },
    unpacker: ->(unpacker) { GlobalID.parse unpacker.read }
  )

end
