# frozen_string_literal: true

class UniversalID::Packer::BigDecimalTest < Minitest::Test
  def test_pack_unpack
    expected = BigDecimal("9876543210.0123456789")
    packed = UniversalID::Packer.pack(expected)
    actual = UniversalID::Packer.unpack(packed)

    assert_equal 25, packed.size
    assert_equal "\xC7\x16\x01\xB59876543210.0123456789".b, packed
    assert_equal expected, actual
  end
end

class UniversalID::Encoder::BigDecimalTest < Minitest::Test
  def test_encode_decode
    expected = BigDecimal("9876543210.0123456789")
    encoded = UniversalID::Encoder.encode(expected)
    actual = UniversalID::Encoder.decode(encoded)

    assert_equal 39, encoded.size
    assert_equal "CwyAxxYBtTk4NzY1NDMyMTAuMDEyMzQ1Njc4OQM", encoded
    assert_equal expected, actual
  end
end

class URI::UID::BigDecimalTest < Minitest::Test
  def test_build_parse_decode
    expected = BigDecimal("9876543210.0123456789")
    uri = URI::UID.build(expected).to_s
    uid = URI::UID.parse(uri)
    actual = uid.decode

    assert uri.start_with?("uid://universalid/CwyAxxYBtTk4NzY1NDMyMTAuMDEyMzQ1Njc4OQM")
    assert_equal expected, actual
  end

  def test_global_id
    expected = BigDecimal("9876543210.0123456789")
    gid = URI::UID.build(expected).to_gid_param
    uid = URI::UID.from_gid(gid)
    actual = uid.decode

    assert_equal expected, actual
  end

  def test_signed_global_id
    expected = BigDecimal("9876543210.0123456789")
    sgid = URI::UID.build(expected).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    actual = uid.decode

    assert_equal expected, actual
  end
end
