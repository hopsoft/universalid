# frozen_string_literal: true

class UniversalID::Packer::TimeTest < Minitest::Test
  def test_pack_unpack
    value = Time.new(2024, 4, 17, 8, 22, 39, 42)
    packed = UniversalID::Packer.pack(value)
    unpacked = UniversalID::Packer.unpack(packed)

    assert_equal 6, packed.size
    assert_equal "\xD6\xFFf\x1F\x86\xA5".b, packed
    assert_equal value, unpacked
  end
end

class UniversalID::Encoder::TimeTest < Minitest::Test
  def test_encode_decode
    value = Time.new(2024, 4, 17, 8, 22, 39, 42)
    encoded = UniversalID::Encoder.encode(value)
    decoded = UniversalID::Encoder.decode(encoded)

    assert_equal 14, encoded.size
    assert_equal "iwKA1v9mH4alAw", encoded
    assert_equal value, decoded
  end
end

class URI::UID::TimeTest < Minitest::Test
  def test_build_parse_decode
    value = Time.new(2024, 4, 17, 8, 22, 39, 42)
    uri = URI::UID.build(value).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    assert uri.start_with?("uid://universalid/iwKA1v9mH4alAw")
    assert_equal value, decoded
  end

  def test_global_id
    value = Time.new(2024, 4, 17, 8, 22, 39, 42)
    gid = URI::UID.build(value).to_gid_param
    uid = URI::UID.from_gid(gid)
    decoded = uid.decode

    assert_equal value, decoded
  end

  def test_signed_global_id
    value = Time.new(2024, 4, 17, 8, 22, 39, 42)
    sgid = URI::UID.build(value).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    decoded = uid.decode

    assert_equal value, decoded
  end
end
