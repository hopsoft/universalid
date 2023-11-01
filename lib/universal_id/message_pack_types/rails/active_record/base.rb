# frozen_string_literal: true

using UniversalID::Refinements::Kernel

def extract_attributes(record)
  return record.attributes if record.new_record?
  return nil unless record.changed?

  options = Thread.current[:universal_id].dig(:encode, :active_record)
  options[:keep_changes] ? record.changes.transform_values(&:last) : nil
end

if defined? ActiveRecord::Base
  UniversalID::MessagePackTypes.register ActiveRecord::Base,
    # to_msgpack_ext
    packer: ->(record) do
      MessagePack.pack record.persisted? ?
        [record.to_gid_param, extract_attributes(record)] :
        [record.class.name, extract_attributes(record)]
    end,

    # from_msgpack_ext
    unpacker: ->(string) do
      head, attributes = MessagePack.unpack(string)
      gid = GlobalID.parse(head)
      record = gid ? gid.find : const_find(head)&.new
      record.assign_attributes attributes if attributes
      record
    end
end
