# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::HashWithGIDTest < ActiveSupport::TestCase
  def setup
    @hash = UniversalID::HashWithGID.new(
      id: 1,
      test: true,
      example: "value",
      other: nil,
      created_at: Time.current,
      updated_at: Time.current,
      nested: {
        keep: "value to keep",
        remove: "value to remove"
      },
      options: {block_list: %w[id created_at updated_at remove]}
    )
  end

  def test_find_invalid_id
    invalid_id = SecureRandom.hex

    error = assert_raises(UniversalID::LocatorError) do
      UniversalID::HashWithGID.find invalid_id
    end

    assert error.message.include?("Failed to locate the id")
    assert error.message.include?(invalid_id)
    assert_equal invalid_id, error.id
    assert error.cause
  end

  def test_to_gid
    gid = @hash.to_gid

    expected = {
      uri: "gid://UniversalID/UniversalID::HashWithGID/eNqrVipJLS5RsiopKk3VUUqtSMwtyElVslIqS8wpTVXSUcoDyqamKFlVK2WnphbAJBRK8hXA_NpaAOIHFl8",
      param: "Z2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6Okhhc2hXaXRoR0lEL2VOcXJWaXBKTFM1UnNpb3BLazNWVVVxdFNNd3R5RWxWc2xJcVM4d3BUVlhTVWNvRHlxYW1LRmxWSzJXbnBoYkFKQlJLOGhYQV9OcGFBT0lIRmw4",
      hash: {"test" => true, "example" => "value", "nested" => {"keep" => "value to keep"}}
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
      param: "BAh7CEkiCGdpZAY6BkVUSSIBfmdpZDovL1VuaXZlcnNhbElEL1VuaXZlcnNhbElEOjpIYXNoV2l0aEdJRC9lTnFyVmlwSkxTNVJzaW9wS2szVlVVcXRTTXd0eUVsVnNsSXFTOHdwVFZYU1Vjb0R5cWFtS0ZsVksyV25waGJBSkJSSzhoWEFfTnBhQU9JSEZsOAY7AFRJIgxwdXJwb3NlBjsAVEkiDGRlZmF1bHQGOwBUSSIPZXhwaXJlc19hdAY7AFQw--586c8a1a977c57cbf7596e6b942353d6424cdf5c",
      hash: {"test" => true, "example" => "value", "nested" => {"keep" => "value to keep"}}
    }

    assert_equal expected[:param], sgid.to_s
    assert_equal expected[:param], sgid.to_param
    assert_equal expected[:hash], sgid.find
    assert_equal sgid, SignedGlobalID.parse(expected[:param])
  end
end
