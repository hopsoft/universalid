# frozen_string_literal: true

UniversalID::MessagePackFactory.register(
  type: ActiveSupport::TimeWithZone,
  packer: ->(obj, packer) do
    packer.write obj.iso8601(9)
    packer.write obj.zone
  end,
  unpacker: ->(unpacker) do
    time = Time.parse(unpacker.read)
    zone = unpacker.read
    ActiveSupport::TimeWithZone.new time, ActiveSupport::TimeZone[zone]
  end
)
