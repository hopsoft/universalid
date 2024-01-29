# frozen_string_literal: true

class UniversalID::Packer::RegexpTest < Minitest::Test
  def test_pack_unpack
    value = /\Aexample\d{2,}/i
    packed = UniversalID::Packer.pack(value)
    unpacked = UniversalID::Packer.unpack(packed)

    assert_equal 20, packed.size
    assert_equal "\xC7\x11\a\xAF\\Aexample\\d{2,}\x01".b, packed
    assert_equal value, unpacked
  end
end

class UniversalID::Encoder::RegexpTest < Minitest::Test
  def test_encode_decode
    value = /\Aexample\d{2,}/i
    encoded = UniversalID::Encoder.encode(value)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal 32, encoded.size
    assert_equal "iwmAxxEHr1xBZXhhbXBsZVxkezIsfQED", encoded
    assert_equal value, decoded
  end
end

class URI::UID::RegexpTest < Minitest::Test
  def test_build_parse_decode
    value = /\Aexample\d{2,}/i
    uri = URI::UID.build(value).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    assert uri.start_with?("uid://universalid/iwmAxxEHr1xBZXhhbXBsZVxkezIsfQED")
    assert_equal value, decoded
  end

  def test_global_id
    value = /\Aexample\d{2,}/i
    gid = URI::UID.build(value).to_gid_param
    uid = URI::UID.from_gid(gid)
    decoded = uid.decode

    assert_equal value, decoded
  end

  def test_signed_global_id
    value = /\Aexample\d{2,}/i
    sgid = URI::UID.build(value).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    decoded = uid.decode

    assert_equal value, decoded
  end
end
