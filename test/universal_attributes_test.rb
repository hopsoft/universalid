# frozen_string_literal: true

require_relative "test_helper"

class UniversalAttributesTest < ActiveSupport::TestCase
  setup do
    hash = {id: 1, test: true, example: "value", other: nil, created_at: Time.current, updated_at: Time.current}
    @universal_attributes = UniversalID::Attributes.new(hash)
    @gid_options = {app: "test-gid", verifier: GlobalID::Verifier.new("secret")}.freeze
  end

  def test_to_gid_app
    assert_equal "test-gid", @universal_attributes.to_gid(app: "test-gid").app
  end

  def test_to_gid
    gid = @universal_attributes.to_gid(@gid_options)
    assert_equal({"test" => true, "example" => "value"}, gid.find)
  end

  def test_to_sgid_app
    assert_equal "test-gid", @universal_attributes.to_sgid(@gid_options).app
  end

  def test_to_sgid
    sgid = @universal_attributes.to_sgid(@gid_options)
    assert_equal({"test" => true, "example" => "value"}, sgid.find)
  end
end
