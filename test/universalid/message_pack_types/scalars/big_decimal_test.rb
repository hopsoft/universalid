# frozen_string_literal: true

class UniversalID::Packer::BigDecimalTest < Minitest::Test
  def test_pack_and_unpack
    value = BigDecimal("9876543210.0123456789")
    packed = UniversalID::Packer.pack(value)
    unpacked = UniversalID::Packer.unpack(packed)

    assert_equal 25, packed.size
    assert_equal "\xC7\x16\x01\xB59876543210.0123456789".b, packed
    assert_equal value, unpacked
  end
end

class UniversalID::Encoder::BigDecimalTest < Minitest::Test
  def test_encode_and_decode
    value = BigDecimal("9876543210.0123456789")
    encoded = UniversalID::Encoder.encode(value)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal 39, encoded.size
    assert_equal "CwyAxxYBtTk4NzY1NDMyMTAuMDEyMzQ1Njc4OQM", encoded
    assert_equal value, decoded
  end
end

class URI::UID::BigDecimalTest < Minitest::Test
  def test_build_parse_decode
    value = BigDecimal("9876543210.0123456789")
    uri = URI::UID.build(value).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    assert uri.start_with?("uid://universalid/CwyAxxYBtTk4NzY1NDMyMTAuMDEyMzQ1Njc4OQM")
    assert_equal value, decoded
  end

  def test_global_id
    value = BigDecimal("9876543210.0123456789")
    gid = URI::UID.build(value).to_gid_param
    uid = URI::UID.from_gid(gid)
    decoded = uid.decode

    assert_equal "Z2lkOi8vdW5pdmVyc2FsLWlkL1VuaXZlcnNhbElEOjpFeHRlbnNpb25zOjpHbG9iYWxJRE1vZGVsL0N3eUF4eFlCdFRrNE56WTFORE15TVRBdU1ERXlNelExTmpjNE9RTQ", gid
    assert_equal value, decoded
  end

  def test_signed_global_id
    value = BigDecimal("9876543210.0123456789")
    sgid = URI::UID.build(value).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    decoded = uid.decode

    assert_equal "eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaEpJbVpuYVdRNkx5OTFibWwyWlhKellXd3RhV1F2Vlc1cGRtVnljMkZzU1VRNk9rVjRkR1Z1YzJsdmJuTTZPa2RzYjJKaGJFbEVUVzlrWld3dlEzZDVRWGg0V1VKMFZHczBUbnBaTVU1RVRYbE5WRUYxVFVSRmVVMTZVVEZPYW1NMFQxRk5Cam9HUlZRPSIsImV4cCI6bnVsbCwicHVyIjoiZGVmYXVsdCJ9fQ==--7fbfd828dbd6864c4aa022cb99e8b61385a99c3d", sgid
    assert_equal value, decoded
  end
end
