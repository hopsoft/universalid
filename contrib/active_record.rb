# frozen_string_literal: true

if defined?(ActiveRecord) && defined?(ActiveRecord::Base) && defined?(ActiveRecord::Relation)

  require_relative "active_record/base_message_pack_type"
  require_relative "active_record/relation_message_pack_type"

end
