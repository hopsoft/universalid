# frozen_string_literal: true

if defined? ActiveRecord::Base

  require_relative "base_packer"
  require_relative "base_unpacker"

  UniversalID::MessagePackFactory.register(
    type: ActiveRecord::Base,
    recreate_pool: false,
    packer: ->(obj, packer) { UniversalID::Extensions::ActiveRecordBasePacker.new(obj).pack_with packer },
    unpacker: ->(unpacker) { UniversalID::Extensions::ActiveRecordBaseUnpacker.unpack_with unpacker }
  )

end
