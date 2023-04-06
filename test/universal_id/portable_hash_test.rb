# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::PortableHashTest < ActiveSupport::TestCase
  def setup
    UniversalID.config.portable_hash[:except] = %w[id created_at updated_at]
    @hash = UniversalID::PortableHash.new(
      id: 1,
      test: true,
      example: "value",
      other: nil,
      created_at: Time.current,
      updated_at: Time.current,
      nested: {
        keep: "keep",
        remove: "remove"
      },
      portable_hash_options: {except: %w[remove]} # combines with config
    )
  end

  def test_config
    expected = {allow_blank: false, only: [], except: ["id", "created_at", "updated_at"]}
    assert_equal expected, UniversalID.config.portable_hash
  end

  def test_options
    expected = {allow_blank: false, only: [], except: ["id", "created_at", "updated_at", "remove"]}
    assert_equal expected.with_indifferent_access, @hash.options
  end

  def test_id
    assert_equal "eNqrVipJLS5RsiopKk3VUUqtSMwtyElVslIqS8wpTVXSUcoDyqamKFlVK2WnphYAJcBUbS0AJkYTHw", @hash.id
  end

  def test_find
    assert_equal @hash, UniversalID::PortableHash.find(@hash.id)
  end

  def test_find_invalid
    invalid_id = SecureRandom.hex

    error = assert_raises(UniversalID::LocatorError) do
      UniversalID::PortableHash.find invalid_id
    end

    assert error.message.include?("Failed to locate the id")
    assert error.message.include?(invalid_id)
    assert_equal invalid_id, error.id
    assert error.cause
  end

  def test_parse_gid
    gid = @hash.to_gid
    sgid = @hash.to_sgid
    assert_equal gid, UniversalID::PortableHash.parse_gid(gid)
    assert_equal sgid, UniversalID::PortableHash.parse_gid(sgid)
  end

  def test_to_gid
    gid = @hash.to_gid

    expected = {
      uri: "gid://UniversalID/UniversalID::PortableHash/eNqrVipJLS5RsiopKk3VUUqtSMwtyElVslIqS8wpTVXSUcoDyqamKFlVK2WnphYAJcBUbS0AJkYTHw",
      param: "Z2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6OlBvcnRhYmxlSGFzaC9lTnFyVmlwSkxTNVJzaW9wS2szVlVVcXRTTXd0eUVsVnNsSXFTOHdwVFZYU1Vjb0R5cWFtS0ZsVksyV25waFlBSmNCVWJTMEFKa1lUSHc",
      hash: {"test" => true, "example" => "value", "nested" => {"keep" => "keep"}}
    }

    assert_equal expected[:uri], gid.to_s
    assert_equal expected[:param], gid.to_param
    assert_equal expected[:hash], gid.find
    assert_equal gid, GlobalID.parse(expected[:uri])
    assert_equal gid, GlobalID.parse(expected[:param])
  end

  def test_to_sgid
    sgid = @hash.to_sgid

    expected = {
      param: "BAh7CEkiCGdpZAY6BkVUSSJ_Z2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6OlBvcnRhYmxlSGFzaC9lTnFyVmlwSkxTNVJzaW9wS2szVlVVcXRTTXd0eUVsVnNsSXFTOHdwVFZYU1Vjb0R5cWFtS0ZsVksyV25waFlBSmNCVWJTMEFKa1lUSHcGOwBUSSIMcHVycG9zZQY7AFRJIgxkZWZhdWx0BjsAVEkiD2V4cGlyZXNfYXQGOwBUMA==--9d0357c4175a7b1c03f3006c81eb6b9ff04feefc",
      hash: {"test" => true, "example" => "value", "nested" => {"keep" => "keep"}}
    }

    assert_equal expected[:param], sgid.to_s
    assert_equal expected[:param], sgid.to_param
    assert_equal expected[:hash], sgid.find
    assert_equal sgid, SignedGlobalID.parse(expected[:param])
  end
end
