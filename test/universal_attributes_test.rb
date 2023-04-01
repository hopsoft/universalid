# frozen_string_literal: true

require_relative "test_helper"

class UniversalAttributesTest < ActiveSupport::TestCase
  setup do
    hash = {id: 1, test: true, example: "value", other: nil, created_at: Time.current, updated_at: Time.current}
    @universal_attributes = UniversalID::Attributes.new(hash)
    @gid_options = {app: "test-gid", verifier: GlobalID::Verifier.new("secret")}
  end

  def test_to_gid_app
    assert_equal "test-gid", @universal_attributes.to_gid(app: "test-gid").app
  end

  def test_to_gid
    gid = @universal_attributes.to_gid(@gid_options)
    assert_equal "gid://test-gid/UniversalID::Attributes/eNqrVipJLS5RsiopKk3VUUqtSMwtyElVslIqS8wpTVWqBQCv9wru", gid.to_s
    assert_equal "Z2lkOi8vdGVzdC1naWQvVW5pdmVyc2FsSUQ6OkF0dHJpYnV0ZXMvZU5xclZpcEpMUzVSc2lvcEtrM1ZVVXF0U013dHlFbFZzbElxUzh3cFRWV3FCUUN2OXdydQ", gid.to_param
    expected = {"test" => true, "example" => "value"}
    assert_equal expected, gid.find
    assert_equal gid, GlobalID.parse(gid.to_s, @gid_options)
    assert_equal gid, GlobalID.parse(gid.to_param, @gid_options)
  end

  def test_to_sgid_app
    assert_equal "test-gid", @universal_attributes.to_sgid(@gid_options).app
  end

  def test_to_sgid
    sgid = @universal_attributes.to_sgid(@gid_options)
    expected = "BAh7CEkiCGdpZAY6BkVUSSJgZ2lkOi8vdGVzdC1naWQvVW5pdmVyc2FsSUQ6OkF0dHJpYnV0ZXMvZU5xclZpcEpMUzVSc2lvcEtrM1ZVVXF0U013dHlFbFZzbElxUzh3cFRWV3FCUUN2OXdydQY7AFRJIgxwdXJwb3NlBjsAVEkiDGRlZmF1bHQGOwBUSSIPZXhwaXJlc19hdAY7AFQw--dd496edc94ad3bf7f9604db57bbdeaf91f563d5f"
    assert_equal expected, sgid.to_s
    assert_equal expected, sgid.to_param
    expected = {"test" => true, "example" => "value"}
    assert_equal expected, sgid.find
    assert_equal sgid, SignedGlobalID.parse(sgid.to_param, @gid_options)
  end
end
