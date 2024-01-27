# frozen_string_literal: true

if defined? ActiveSupport::TimeWithZone

  UniversalID::MessagePackFactory.register(
    type: ActiveSupport::TimeWithZone,
    packer: ->(obj, packer) do
      packer.write obj.to_time.utc
      packer.write obj.time_zone.tzinfo.identifier
    end,
    unpacker: ->(unpacker) do
      utc = unpacker.read
      tz = unpacker.read
      utc.in_time_zone ActiveSupport::TimeZone[tz]
    end
  )

end
