# frozen_string_literal: true

class UniversalID::Packer::NilClassTest < Minitest::Test
  def test_pack_unpack
    expected = nil
    packed = UniversalID::Packer.pack(expected)
    actual = UniversalID::Packer.unpack(packed)

    assert_equal 1, packed.size
    assert_equal "\xC0".b, packed
    assert_nil actual
  end
end

class UniversalID::Encoder::NilClassTest < Minitest::Test
  def test_encode_decode
    expected = nil
    encoded = UniversalID::Encoder.encode(expected)
    actual = UniversalID::Encoder.decode(encoded)

    assert_equal 7, encoded.size
    assert_equal "CwCAwAM", encoded
    assert_nil actual
  end
end

class URI::UID::NilClassTest < Minitest::Test
  def test_build_parse_decode
    expected = nil
    uri = URI::UID.build(expected).to_s
    uid = URI::UID.parse(uri)
    actual = uid.decode

    assert uri.start_with?("uid://universalid/CwCAwAM")
    assert_nil actual
  end

  def test_global_id
    expected = nil
    gid = URI::UID.build(expected).to_gid_param
    uid = URI::UID.from_gid(gid)
    actual = uid.decode

    assert_nil actual
  end

  def test_signed_global_id
    expected = nil
    sgid = URI::UID.build(expected).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    actual = uid.decode

    assert_nil actual
  end
end
