# frozen_string_literal: true

class UniversalID::Packer::SetTest < Minitest::Test
  def test_pack_unpack
    expected = Set.new(scalars.values)
    packed = UniversalID::Packer.pack(expected)
    actual = UniversalID::Packer.unpack(packed)

    assert_equal expected, actual
  end
end

class UniversalID::Encoder::SetTest < Minitest::Test
  def test_encode_decode
    expected = Set.new(scalars.values)
    encoded = UniversalID::Encoder.encode(expected)
    actual = UniversalID::Encoder.decode(encoded)

    assert_equal expected, actual
  end
end

class URI::UID::SetTest < Minitest::Test
  def test_build_parse_decode
    expected = Set.new(scalars.values)
    uri = URI::UID.build(expected).to_s
    uid = URI::UID.parse(uri)
    actual = uid.decode

    assert_equal expected, actual
  end

  def test_global_id
    expected = Set.new(scalars.values)
    gid = URI::UID.build(expected).to_gid_param
    uid = URI::UID.from_gid(gid)
    actual = uid.decode

    assert_equal expected, actual
  end

  def test_signed_global_id
    expected = Set.new(scalars.values)
    sgid = URI::UID.build(expected).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    actual = uid.decode

    assert_equal expected, actual
  end
end
