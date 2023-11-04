# frozen_string_literal: true

require_relative "packer"
require_relative "unpacker"

if defined? ::GlobalID::Identification

  ::UniversalID::MessagePackFactory.register_next_type ::GlobalID::Identification,
    packer: ->(obj, packer) { ::UniversalID::GlobalIDIdentificationPacker.new(obj).pack_with packer },
    unpacker: ->(unpacker) { ::UniversalID::GlobalIDIdentificationUnpacker.unpack_with unpacker },
    recursive: true

end
