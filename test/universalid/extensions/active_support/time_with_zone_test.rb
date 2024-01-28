# frozen_string_literal: true

class URI::UID::TimeWithZoneTest < Minitest::Test
  def test_uid_build_and_decode_for_all_active_support_time_zones
    month = ActiveSupport::TimeZone["UTC"].now.beginning_of_year

    Timecop.freeze time do
      11.times do |i|
        ActiveSupport::TimeZone.all.each do |time_zone|
          time = month.in_time_zone(time_zone).advance(days: rand(1..28), minutes: rand(1..59))

          assert time.is_a?(ActiveSupport::TimeWithZone)

          uri = URI::UID.build(time).to_s
          uid = URI::UID.parse(uri)
          decoded = uid.decode

          assert_equal time, decoded
        end

        month.advance months: 1
      end
    end
  end
end
