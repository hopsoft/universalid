# frozen_string_literal: true

class UniversalID::Packer::StringTest < Minitest::Test
  def test_pack_unpack
    expected = "This is a string!"
    packed = UniversalID::Packer.pack(expected)
    actual = UniversalID::Packer.unpack(packed)

    assert_equal 18, packed.size
    assert_equal "\xB1This is a string!".b, packed
    assert_equal expected, actual
  end
end

class UniversalID::Encoder::StringTest < Minitest::Test
  def test_encode_decode
    expected = "This is a string!"
    encoded = UniversalID::Encoder.encode(expected)
    actual = UniversalID::Encoder.decode(encoded)

    assert_equal 27, encoded.size
    assert_equal "GxEA-KVBQsJipSKNUFKwLNSnHEI", encoded
    assert_equal expected, actual
  end
end

class URI::UID::StringTest < Minitest::Test
  def test_build_parse_decode
    expected = "This is a string!"
    uri = URI::UID.build(expected).to_s
    uid = URI::UID.parse(uri)
    actual = uid.decode

    assert uri.start_with?("uid://universalid/GxEA-KVBQsJipSKNUFKwLNSnHEI")
    assert_equal expected, actual
  end

  def test_global_id
    expected = "This is a string!"
    gid = URI::UID.build(expected).to_gid_param
    uid = URI::UID.from_gid(gid)
    actual = uid.decode

    assert_equal expected, actual
  end

  def test_signed_global_id
    expected = "This is a string!"
    sgid = URI::UID.build(expected).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    actual = uid.decode

    assert_equal expected, actual
  end
end
