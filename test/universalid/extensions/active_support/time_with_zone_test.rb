# frozen_string_literal: true

class UniversalID::Packer::TimeWithZoneTest < Minitest::Test
  def test_pack_unpack
    time_with_zones do |expected|
      packed = UniversalID::Packer.pack(expected)
      actual = UniversalID::Packer.unpack(packed)

      assert_kind_of ActiveSupport::TimeWithZone, expected
      assert_kind_of ActiveSupport::TimeWithZone, actual
      assert_equal expected, actual
    end
  end
end

class UniversalID::Encoder::TimeWithZoneTest < Minitest::Test
  def test_encode_decode
    time_with_zones do |expected|
      encoded = UniversalID::Encoder.encode(expected)
      actual = UniversalID::Encoder.decode(encoded)

      assert_kind_of ActiveSupport::TimeWithZone, expected
      assert_kind_of ActiveSupport::TimeWithZone, actual
      assert_equal expected, actual
    end
  end
end

class URI::UID::TimeWithZoneTest < Minitest::Test
  def test_build_parse_decode
    time_with_zones do |expected|
      uri = URI::UID.build(expected).to_s
      uid = URI::UID.parse(uri)
      actual = uid.decode

      assert_kind_of ActiveSupport::TimeWithZone, expected
      assert_kind_of ActiveSupport::TimeWithZone, actual
      assert_equal expected, actual
    end
  end

  def test_global_id
    time_with_zones do |expected|
      gid = URI::UID.build(expected).to_gid_param
      uid = URI::UID.from_gid(gid)
      actual = uid.decode

      assert_kind_of ActiveSupport::TimeWithZone, expected
      assert_kind_of ActiveSupport::TimeWithZone, actual
      assert_equal expected, actual
    end
  end

  def test_signed_global_id
    time_with_zones do |expected|
      sgid = URI::UID.build(expected).to_sgid_param
      uid = URI::UID.from_sgid(sgid)
      actual = uid.decode

      assert_kind_of ActiveSupport::TimeWithZone, expected
      assert_kind_of ActiveSupport::TimeWithZone, actual
      assert_equal expected, actual
    end
  end
end
