# frozen_string_literal: true

class UniversalID::Packer::RegexpTest < Minitest::Test
  def test_pack_unpack
    expected = /\Aexample\d{2,}/i
    packed = UniversalID::Packer.pack(expected)
    actual = UniversalID::Packer.unpack(packed)

    assert_equal 20, packed.size
    assert_equal "\xC7\x11\a\xAF\\Aexample\\d{2,}\x01".b, packed
    assert_equal expected, actual
  end
end

class UniversalID::Encoder::RegexpTest < Minitest::Test
  def test_encode_decode
    expected = /\Aexample\d{2,}/i
    encoded = UniversalID::Encoder.encode(expected)
    actual = UniversalID::Encoder.decode(encoded)

    assert_equal 32, encoded.size
    assert_equal "iwmAxxEHr1xBZXhhbXBsZVxkezIsfQED", encoded
    assert_equal expected, actual
  end
end

class URI::UID::RegexpTest < Minitest::Test
  def test_build_parse_decode
    expected = /\Aexample\d{2,}/i
    uri = URI::UID.build(expected).to_s
    uid = URI::UID.parse(uri)
    actual = uid.decode

    assert uri.start_with?("uid://universalid/iwmAxxEHr1xBZXhhbXBsZVxkezIsfQED")
    assert_equal expected, actual
  end

  def test_global_id
    expected = /\Aexample\d{2,}/i
    gid = URI::UID.build(expected).to_gid_param
    uid = URI::UID.from_gid(gid)
    actual = uid.decode

    assert_equal expected, actual
  end

  def test_signed_global_id
    expected = /\Aexample\d{2,}/i
    sgid = URI::UID.build(expected).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    actual = uid.decode

    assert_equal expected, actual
  end
end
