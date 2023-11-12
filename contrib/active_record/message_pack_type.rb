# frozen_string_literal: true

UniversalID::MessagePackFactory.register(
  type: ActiveRecord::Base,
  recreate_pool: false,
  packer: ->(obj, packer) { UniversalID::Contrib::ActiveRecordPacker.new(obj).pack_with packer },
  unpacker: ->(unpacker) { UniversalID::Contrib::ActiveRecordUnpacker.unpack_with unpacker }
)