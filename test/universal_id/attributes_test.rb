# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::AttributesTest < ActiveSupport::TestCase
  setup do
    @attributes = UniversalID::Attributes.new(
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
      UniversalID::Attributes.find invalid_id
    end

    assert error.message.include?("Failed to locate the id")
    assert error.message.include?(invalid_id)
    assert_equal invalid_id, error.id
    assert error.cause
  end

  def test_to_gid
    gid = @attributes.to_gid(@gid_options)

    expected = {
      uri: "gid://test-gid/UniversalID::Attributes/eNqrVipJLS5RsiopKk3VUUqtSMwtyElVslIqS8wpTVWqBQCv9wru",
      param: "Z2lkOi8vdGVzdC1naWQvVW5pdmVyc2FsSUQ6OkF0dHJpYnV0ZXMvZU5xclZpcEpMUzVSc2lvcEtrM1ZVVXF0U013dHlFbFZzbElxUzh3cFRWV3FCUUN2OXdydQ",
      hash: {"test" => true, "example" => "value"}
    }

    assert_equal expected[:uri], gid.to_s
    assert_equal expected[:param], gid.to_param
    assert_equal expected[:hash], gid.find
    assert_equal gid, GlobalID.parse(gid.to_s, @gid_options)
    assert_equal gid, GlobalID.parse(gid.to_param, @gid_options)
  end

  def test_to_sgid
    sgid = @attributes.to_sgid(@sgid_options)

    expected = {
      param: "BAh7CEkiCGdpZAY6BkVUSSJrZ2lkOi8vdGVzdC1naWQvVW5pdmVyc2FsSUQ6OkF0dHJpYnV0ZXMvZU5xclZpcEpMUzVSc2lvcEtrM1ZVVXF0U013dHlFbFZzbElxUzh3cFRWV3FCUUN2OXdydT9leHBpcmVzX2luBjsAVEkiDHB1cnBvc2UGOwBUSSIMZGVmYXVsdAY7AFRJIg9leHBpcmVzX2F0BjsAVDA=--6f7e21af378017145212cc958a8519beef281761",
      hash: {"test" => true, "example" => "value"}
    }

    assert_equal expected[:param], sgid.to_s
    assert_equal expected[:param], sgid.to_param
    assert_equal expected[:hash], sgid.find
    assert_equal sgid, SignedGlobalID.parse(sgid.to_param, @sgid_options)
  end
end
