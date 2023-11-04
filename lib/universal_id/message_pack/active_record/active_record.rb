# frozen_string_literal: true

require_relative "active_record_packer"
require_relative "active_record_unpacker"

if defined? ::ActiveRecord::Base

  ::UniversalID::MessagePackFactory.register_next_type ::ActiveRecord::Base,
    packer: ->(obj, packer) { ::UniversalID::ActiveRecordPacker.new(obj).pack_with packer },
    unpacker: ->(unpacker) { ::UniversalID::ActiveRecordUnpacker.unpack_with unpacker },
    recursive: true

end
