# frozen_string_literal: true

class UniversalID::Packer::ComplexTest < Minitest::Test
  def test_pack_unpack
    expected = Complex(2, 3)
    packed = UniversalID::Packer.pack(expected)
    actual = UniversalID::Packer.unpack(packed)

    assert_equal 8, packed.size
    assert_equal "\xC7\x05\x02\xA42+3i".b, packed
    assert_equal expected, actual
  end
end

class UniversalID::Encoder::ComplexTest < Minitest::Test
  def test_encode_decode
    expected = Complex(2, 3)
    encoded = UniversalID::Encoder.encode(expected)
    actual = UniversalID::Encoder.decode(encoded)

    assert_equal 16, encoded.size
    assert_equal "iwOAxwUCpDIrM2kD", encoded
    assert_equal expected, actual
  end
end

class URI::UID::ComplexTest < Minitest::Test
  def test_build_parse_decode
    expected = Complex(2, 3)
    uri = URI::UID.build(expected).to_s
    uid = URI::UID.parse(uri)
    actual = uid.decode

    assert uri.start_with?("uid://universalid/iwOAxwUCpDIrM2kD")
    assert_equal expected, actual
  end

  def test_global_id
    expected = Complex(2, 3)
    gid = URI::UID.build(expected).to_gid_param
    uid = URI::UID.from_gid(gid)
    actual = uid.decode

    assert_equal expected, actual
  end

  def test_signed_global_id
    expected = Complex(2, 3)
    sgid = URI::UID.build(expected).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    actual = uid.decode

    assert_equal expected, actual
  end
end
