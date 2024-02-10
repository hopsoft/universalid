# frozen_string_literal: true

if defined? ActiveSupport::Cache::Entry

  UniversalID::MessagePackFactory.register(
    type: ActiveSupport::Cache::Entry,
    packer: ->(obj, packer) do
      packer.write obj.value
      packer.write obj.version
      packer.write obj.expires_at
    end,
    unpacker: ->(unpacker) do
      value = unpacker.read
      version = unpacker.read
      expires_at = unpacker.read
      ActiveSupport::Cache::Entry.new value, version: version, expires_at: expires_at
    end
  )

end
