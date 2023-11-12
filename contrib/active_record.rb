# frozen_string_literal: true

if defined?(ActiveRecord) && defined?(ActiveRecord::Base)

  require_relative "active_record/active_record_packer"
  require_relative "active_record/active_record_unpacker"
  require_relative "active_record/message_pack_type"

end
