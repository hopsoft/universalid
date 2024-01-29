# frozen_string_literal: true

class UniversalID::Packer::ComplexTest < Minitest::Test
  def test_pack_unpack
    value = Complex(2, 3)
    packed = UniversalID::Packer.pack(value)
    unpacked = UniversalID::Packer.unpack(packed)

    assert_equal 8, packed.size
    assert_equal "\xC7\x05\x02\xA42+3i".b, packed
    assert_equal value, unpacked
  end
end

class UniversalID::Encoder::ComplexTest < Minitest::Test
  def test_encode_decode
    value = Complex(2, 3)
    encoded = UniversalID::Encoder.encode(value)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal 16, encoded.size
    assert_equal "iwOAxwUCpDIrM2kD", encoded
    assert_equal value, decoded
  end
end

class URI::UID::ComplexTest < Minitest::Test
  def test_build_parse_decode
    value = Complex(2, 3)
    uri = URI::UID.build(value).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    assert uri.start_with?("uid://universalid/iwOAxwUCpDIrM2kD")
    assert_equal value, decoded
  end

  def test_global_id
    value = Complex(2, 3)
    gid = URI::UID.build(value).to_gid_param
    uid = URI::UID.from_gid(gid)
    decoded = uid.decode

    assert_equal value, decoded
  end

  def test_signed_global_id
    value = Complex(2, 3)
    sgid = URI::UID.build(value).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    decoded = uid.decode

    assert_equal value, decoded
  end
end
