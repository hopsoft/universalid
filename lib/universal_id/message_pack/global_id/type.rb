# frozen_string_literal: true

if defined? ::GlobalID

  ::UniversalID::MessagePackFactory.register_next_type ::GlobalID,
    packer: ->(obj, packer) { packer.write obj.to_param },
    unpacker: ->(unpacker) { ::GlobalID.parse unpacker.read },
    recursive: true

end
