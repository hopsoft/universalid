# frozen_string_literal: true

require_relative "identification_packer"

if defined? ::GlobalID::Identification

  ::UniversalID::MessagePacker.register_type ::GlobalID::Identification,
    packer: ->(obj, packer) { ::UniversalID::GlobalIDIdentificationPacker.new(obj).pack_with packer },
    unpacker: ->(unpacker) { ::UniversalID::GlobalIDIdentificationPacker.new.unpack_with unpacker },
    recursive: true

end
