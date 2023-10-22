# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::HashTest < ActiveSupport::TestCase
  def setup
    @orig_config = UniversalID.config[:packable_hash].dup
    UniversalID.config[:packable_hash][:except] = %w[id created_at updated_at remove]
    @hash = {
      test: true,
      example: "value",
      other: nil,
      created_at: Time.current,
      updated_at: Time.current,
      nested: {
        keep: "keep",
        remove: "remove"
      }
    }
    @packable_hash = UniversalID::PackableHash.new(@hash)
  end

  def teardown
    UniversalID.config[:packable_hash] = @orig_config
  end

  def test_packable_hash
    assert @hash, @packable_hash.to_h
  end

  def test_id
    assert_equal "eNprXlKSWlxyeHlqRWJuQU7q0rLEnNLUZXlAsdSUxiXZqakFYAIAdhkSPA", @packable_hash.id
  end

  def test_cache_key
    assert_equal "UniversalID::PackableHash/c0e15c990791eaa8c00b71a89444e4f2", @packable_hash.cache_key
  end

  def test_find
    expected = {test: true, example: "value", nested: {keep: "keep"}}
    assert_equal expected, UniversalID::PackableHash.find(@packable_hash.id)
  end

  def test_find_invalid
    invalid_id = SecureRandom.hex

    error = assert_raises(UniversalID::LocatorError) do
      UniversalID::PackableHash.find invalid_id
    end

    assert error.message.include?("Failed to locate the id")
    assert error.message.include?(invalid_id)
    assert_equal invalid_id, error.id
    assert error.cause
  end

  def test_to_gid
    gid = @packable_hash.to_gid

    expected = {
      uri: "gid://UniversalID/UniversalID::PackableHash/eNprXlKSWlxyeHlqRWJuQU7q0rLEnNLUZXlAsdSUxiXZqakFYAIAdhkSPA",
      param: "Z2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6OlBhY2thYmxlSGFzaC9lTnByWGxLU1dseHllSGxxUldKdVFVN3EwckxFbk5MVVpYbEFzZFNVeGlYWnFha0ZZQUlBZGhrU1BB",
      hash: {"test" => true, "example" => "value", "nested" => {"keep" => "keep"}}
    }

    assert_equal expected[:uri], gid.to_s
    assert_equal expected[:param], gid.to_param
    assert_equal expected[:hash], gid.find
    assert_equal gid, GlobalID.parse(expected[:uri])
    assert_equal gid, GlobalID.parse(expected[:param])
  end

  def test_to_sgid
    sgid = @packable_hash.to_sgid

    expected = {
      param: "eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaEpJbXRuYVdRNkx5OVZibWwyWlhKellXeEpSQzlWYm1sMlpYSnpZV3hKUkRvNlVHRmphMkZpYkdWSVlYTm9MMlZPY0hKWWJFdFRWMng0ZVdWSWJIRlNWMHAxVVZVM2NUQnlURVZ1VGt4VldsaHNRWE5rVTFWNGFWaGFjV0ZyUmxsQlNVRmthR3RUVUVFR09nWkZWQT09IiwiZXhwIjpudWxsLCJwdXIiOiJkZWZhdWx0In19--c10543bab07e009450c50b945ce5add413ba44b6",
      hash: {"test" => true, "example" => "value", "nested" => {"keep" => "keep"}}
    }

    assert_equal expected[:param], sgid.to_s
    assert_equal expected[:param], sgid.to_param
    assert_equal expected[:hash], sgid.find
    assert_equal sgid, SignedGlobalID.parse(expected[:param])
  end
end
