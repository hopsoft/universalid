# frozen_string_literal: true

if defined?(GlobalID) && defined?(GlobalID::Identification)

  module UniversalID::Contrib::GlobalID; end
  require_relative "global_id/global_id_model"
  require_relative "global_id/global_id_uid_extension"
  require_relative "global_id/message_pack_type"

  URI::UID.include UniversalID::Contrib::GlobalIDUIDExtension
end
