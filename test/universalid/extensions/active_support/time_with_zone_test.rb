# frozen_string_literal: true

class UniversalID::Packer::TimeWithZoneTest < Minitest::Test
  def test_pack_unpack
    time_with_zones do |value|
      packed = UniversalID::Packer.pack(value)
      unpacked = UniversalID::Packer.unpack(packed)

      assert_kind_of ActiveSupport::TimeWithZone, value
      assert_kind_of ActiveSupport::TimeWithZone, unpacked
      assert_equal value, unpacked
    end
  end
end

class UniversalID::Encoder::TimeWithZoneTest < Minitest::Test
  def test_encode_decode
    time_with_zones do |value|
      encoded = UniversalID::Encoder.encode(value)
      decoded = UniversalID::Encoder.decode(encoded)

      assert_kind_of ActiveSupport::TimeWithZone, value
      assert_kind_of ActiveSupport::TimeWithZone, decoded
      assert_equal value, decoded
    end
  end
end

class URI::UID::TimeWithZoneTest < Minitest::Test
  def test_build_parse_decode
    time_with_zones do |value|
      uri = URI::UID.build(value).to_s
      uid = URI::UID.parse(uri)
      decoded = uid.decode

      assert_kind_of ActiveSupport::TimeWithZone, value
      assert_kind_of ActiveSupport::TimeWithZone, decoded
      assert_equal value, decoded
    end
  end

  def test_global_id
    time_with_zones do |value|
      gid = URI::UID.build(value).to_gid_param
      uid = URI::UID.from_gid(gid)
      decoded = uid.decode

      assert_kind_of ActiveSupport::TimeWithZone, value
      assert_kind_of ActiveSupport::TimeWithZone, decoded
      assert_equal value, decoded
    end
  end

  def test_signed_global_id
    time_with_zones do |value|
      sgid = URI::UID.build(value).to_sgid_param
      uid = URI::UID.from_sgid(sgid)
      decoded = uid.decode

      assert_kind_of ActiveSupport::TimeWithZone, value
      assert_kind_of ActiveSupport::TimeWithZone, decoded
      assert_equal value, decoded
    end
  end
end
