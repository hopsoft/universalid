# frozen_string_literal: true

module UniversalID::Contrib::GlobalID; end

require_relative "global_id_model"
require_relative "global_id_uid_extension"

URI::UID.include UniversalID::Contrib::GlobalIDUIDExtension

UniversalID::MessagePackFactory.register(
  type: GlobalID,
  recreate_pool: false,
  packer: ->(obj, packer) { packer.write obj.to_param },
  unpacker: ->(unpacker) { GlobalID.parse unpacker.read }
)
