# frozen_string_literal: true

require_relative "base_packer"
require_relative "base_unpacker"

UniversalID::MessagePackFactory.register(
  type: ActiveRecord::Base,
  recreate_pool: false,
  packer: ->(obj, packer) { UniversalID::Contrib::ActiveRecordBasePacker.new(obj).pack_with packer },
  unpacker: ->(unpacker) { UniversalID::Contrib::ActiveRecordBaseUnpacker.unpack_with unpacker }
)
