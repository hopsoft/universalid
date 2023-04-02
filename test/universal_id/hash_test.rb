# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::HashTest < ActiveSupport::TestCase
  setup do
    @hash = UniversalID::Hash.new(
      id: 1,
      test: true,
      example: "value",
      other: nil,
      created_at: Time.current,
      updated_at: Time.current
    )

    @gid_options = {
      app: "test-gid",
      verifier: GlobalID::Verifier.new("secret")
    }.freeze

    @sgid_options = @gid_options.merge(expires_in: nil).freeze
  end

  def test_find_invalid_id
    invalid_id = SecureRandom.hex

    error = assert_raises(UniversalID::LocatorError) do
      UniversalID::Hash.find invalid_id
    end

    assert error.message.include?("Failed to locate the id")
    assert error.message.include?(invalid_id)
    assert_equal invalid_id, error.id
    assert error.cause
  end

  def test_to_gid
    gid = @hash.to_gid(@gid_options)

    expected = {
      uri: "gid://test-gid/UniversalID::Hash/eNqrVipJLS5RsiopKk3VUUqtSMwtyElVslIqS8wpTVWqBQCv9wru",
      param: "Z2lkOi8vdGVzdC1naWQvVW5pdmVyc2FsSUQ6Okhhc2gvZU5xclZpcEpMUzVSc2lvcEtrM1ZVVXF0U013dHlFbFZzbElxUzh3cFRWV3FCUUN2OXdydQ",
      hash: {"test" => true, "example" => "value"}
    }

    assert_equal expected[:uri], gid.to_s
    assert_equal expected[:param], gid.to_param
    assert_equal expected[:hash], gid.find
    assert_equal gid, GlobalID.parse(gid.to_s, @gid_options)
    assert_equal gid, GlobalID.parse(gid.to_param, @gid_options)
  end

  def test_to_sgid
    sgid = @hash.to_sgid(@sgid_options)

    expected = {
      param: "BAh7CEkiCGdpZAY6BkVUSSJlZ2lkOi8vdGVzdC1naWQvVW5pdmVyc2FsSUQ6Okhhc2gvZU5xclZpcEpMUzVSc2lvcEtrM1ZVVXF0U013dHlFbFZzbElxUzh3cFRWV3FCUUN2OXdydT9leHBpcmVzX2luBjsAVEkiDHB1cnBvc2UGOwBUSSIMZGVmYXVsdAY7AFRJIg9leHBpcmVzX2F0BjsAVDA=--0f1b67e81f1d4928a01b03f6d6d1a347397ab843",
      hash: {"test" => true, "example" => "value"}
    }

    assert_equal expected[:param], sgid.to_s
    assert_equal expected[:param], sgid.to_param
    assert_equal expected[:hash], sgid.find
    assert_equal sgid, SignedGlobalID.parse(sgid.to_param, @sgid_options)
  end
end
