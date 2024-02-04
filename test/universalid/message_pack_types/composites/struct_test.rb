# frozen_string_literal: true

class UniversalID::Packer::StructTest < Minitest::Test
  def test_pack_unpack_dynamic
    expected = Struct.new(*scalars.keys).new(*scalars.values)
    packed = UniversalID::Packer.pack(expected)
    actual = UniversalID::Packer.unpack(packed)

    assert_equal expected.to_h, actual.to_h
  end

  class Scalars < Struct.new(*scalars.keys); end

  def test_pack_unpack_concrete
    expected = Scalars.new(*scalars.values)
    packed = UniversalID::Packer.pack(expected)
    actual = UniversalID::Packer.unpack(packed)

    assert_equal expected, actual
  end
end

class UniversalID::Encoder::StructTest < Minitest::Test
  def test_encode_decode_dynamic
    expected = Struct.new(*scalars.keys).new(*scalars.values)
    encoded = UniversalID::Encoder.encode(expected)
    actual = UniversalID::Encoder.decode(encoded)

    assert_equal expected.to_h, actual.to_h
  end

  class Scalars < Struct.new(*scalars.keys); end

  def test_encode_decode_concrete
    expected = Scalars.new(*scalars.values)
    encoded = UniversalID::Encoder.encode(expected)
    actual = UniversalID::Encoder.decode(encoded)

    assert_equal expected, actual
  end
end

class URI::UID::StructTest < Minitest::Test
  def test_build_parse_decode_dynamic
    expected = Struct.new(*scalars.keys).new(*scalars.values)
    uri = URI::UID.build(expected).to_s
    uid = URI::UID.parse(uri)
    actual = uid.decode

    assert_equal expected.to_h, actual.to_h
  end

  def test_global_id_dynamic
    expected = Struct.new(*scalars.keys).new(*scalars.values)
    gid = URI::UID.build(expected).to_gid_param
    uid = URI::UID.from_gid(gid)
    actual = uid.decode

    assert_equal expected.to_h, actual.to_h
  end

  def test_signed_global_id_dynamic
    expected = Struct.new(*scalars.keys).new(*scalars.values)
    sgid = URI::UID.build(expected).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    actual = uid.decode

    assert_equal expected.to_h, actual.to_h
  end

  class Scalars < Struct.new(*scalars.keys); end

  def test_build_parse_decode_concrete
    expected = Scalars.new(*scalars.values)
    uri = URI::UID.build(expected).to_s
    uid = URI::UID.parse(uri)
    actual = uid.decode

    assert_equal expected, actual
  end

  def test_global_id_concrete
    expected = Scalars.new(*scalars.values)
    gid = URI::UID.build(expected).to_gid_param
    uid = URI::UID.from_gid(gid)
    actual = uid.decode

    assert_equal expected, actual
  end

  def test_signed_global_id_concrete
    expected = Scalars.new(*scalars.values)
    sgid = URI::UID.build(expected).to_sgid_param
    uid = URI::UID.from_sgid(sgid)
    actual = uid.decode

    assert_equal expected, actual
  end
end
