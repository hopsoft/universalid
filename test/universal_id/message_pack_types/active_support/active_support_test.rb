# frozen_string_literal: true

require_relative "../../../test_helper"

module UniversalID::MessagePackTypes
  class ActiveSupportTest < Minitest::Test
    def test_time_with_zone
      time = ActiveSupport::TimeWithZone.new(Time.now, ActiveSupport::TimeZone.new("UTC"))
      packed = UniversalID::MessagePackFactory.pack(time)
      unpacked = UniversalID::MessagePackFactory.unpack(packed)
      assert_equal time, unpacked
    end
  end
end
