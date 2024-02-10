# frozen_string_literal: true

class UniversalID::Packer::ActiveSupportCacheStoreTest < Minitest::Test
  def test_pack_unpack
    expected = ActiveSupport::Cache::MemoryStore.new
    scalars.each { |key, val| expected.write key, val, expires_in: 1.second }
    packed = UniversalID::Packer.pack(expected)
    actual = UniversalID::Packer.unpack(packed)
    assert_active_support_cache_store expected, actual, expires_in: 1.second
  end
end

class UniversalID::Encoder::ActiveSupportCacheStoreTest < Minitest::Test
  def test_encode_decode
    expected = ActiveSupport::Cache::MemoryStore.new
    scalars.each { |key, val| expected.write key, val, expires_in: 1.second }
    encoded = UniversalID::Encoder.encode(expected)
    actual = UniversalID::Encoder.decode(encoded)
    assert_active_support_cache_store expected, actual, expires_in: 1.second
  end
end

class URI::UID::ActiveSupportCacheStoreTest < Minitest::Test
  def test_build_parse_decode
    expected = ActiveSupport::Cache::MemoryStore.new
    scalars.each { |key, val| expected.write key, val, expires_in: 1.second }
    uri = URI::UID.build(expected).to_s
    actual = URI::UID.parse(uri).decode
    assert_active_support_cache_store expected, actual, expires_in: 1.second
  end

  def test_global_id
    expected = ActiveSupport::Cache::MemoryStore.new
    scalars.each { |key, val| expected.write key, val, expires_in: 1.second }
    gid = URI::UID.build(expected).to_gid_param
    actual = URI::UID.from_gid(gid).decode
    assert_active_support_cache_store expected, actual, expires_in: 1.second
  end

  def test_signed_global_id
    expected = ActiveSupport::Cache::MemoryStore.new
    scalars.each { |key, val| expected.write key, val, expires_in: 1.second }
    sgid = URI::UID.build(expected).to_sgid_param
    actual = URI::UID.from_sgid(sgid).decode
    assert_active_support_cache_store expected, actual, expires_in: 1.second
  end
end
