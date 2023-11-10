# frozen_string_literal: true

if defined? ActiveRecord::Base

  require_relative "packer"
  require_relative "unpacker"

  UniversalID::MessagePackFactory.register(
    type: ActiveRecord::Base,
    recreate_pool: false,
    packer: ->(obj, packer) { UniversalID::ActiveRecordBasePacker.new(obj).pack_with packer },
    unpacker: ->(unpacker) { UniversalID::ActiveRecordBaseUnpacker.unpack_with unpacker }
  )

end
