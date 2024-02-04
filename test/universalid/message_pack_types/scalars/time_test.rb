# frozen_string_literal: true

class UniversalID::Packer::TimeTest < Minitest::Test
  def test_pack_unpack
    expected = Time.new(2024, 4, 17, 8, 22, 39, 42)
    packed = UniversalID::Packer.pack(expected)
    actual = UniversalID::Packer.unpack(packed)

    assert_equal 6, packed.size
    assert_equal "\xD6\xFFf\x1F\x86\xA5".b, packed
    assert_equal expected, actual
  end
end

class UniversalID::Encoder::TimeTest < Minitest::Test
  def test_encode_decode
    expected = Time.new(2024, 4, 17, 8, 22, 39, 42)
    encoded = UniversalID::Encoder.encode(expected)
    actual = UniversalID::Encoder.decode(encoded)

    assert_equal 14, encoded.size
    assert_equal "iwKA1v9mH4alAw", encoded
    assert_equal expected, actual
  end
end

class URI::UID::TimeTest < Minitest::Test
  def test_build_parse_decode
    expected = Time.new(2024, 4, 17, 8, 22, 39, 42)
    uri = URI::UID.build(expected).to_s
    uid = URI::UID.parse(uri)
    actual = uid.decode

    assert uri.start_with?("uid://universalid/iwKA1v9mH4alAw")
    assert_equal expected, actual
  end

  def test_global_id
    expected = Time.new(2024, 4, 17, 8, 22, 39, 42)
    gid = URI::UID.build(expected).to_gid_param
    uid = URI::UID.from_gid(gid)
    actual = uid.decode

    assert_equal expected, actual
  end

  def test_signed_global_id
    expected = Time.new(2024, 4, 17, 8, 22, 39, 42)
    sgid = URI::UID.build(expected).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    actual = uid.decode

    assert_equal expected, actual
  end
end
