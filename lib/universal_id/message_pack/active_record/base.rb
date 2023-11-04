# frozen_string_literal: true

require_relative "packer"
require_relative "unpacker"

if defined? ::ActiveRecord::Base

  ::UniversalID::MessagePackFactory.register_next_type ::ActiveRecord::Base,
    packer: ->(obj, packer) { ::UniversalID::ActiveRecordBasePacker.new(obj).pack_with packer },
    unpacker: ->(unpacker) { ::UniversalID::ActiveRecordBaseUnpacker.unpack_with unpacker },
    recursive: true

end
