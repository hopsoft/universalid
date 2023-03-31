# frozen_string_literal: true

require_relative "test_helper"
require_relative "models/user"

class UniversalIDTest < ActiveSupport::TestCase
  setup do
    GlobalID.app = "test"
    SignedGlobalID.app = "test"
    SignedGlobalID.verifier = GlobalID::Verifier.new("test")

    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
    ActiveRecord::Schema.define do
      create_table :users do |t|
        t.column :name, :string
        t.column :email, :string
        t.timestamps
      end
    end
  end

  def test_global_id
    user = User.create!(name: "Test Example")
    gid = user.to_gid
    gid_param = gid.to_param
    assert_equal "test", gid.app
    assert_equal "Z2lkOi8vdGVzdC9Vc2VyLzE", gid_param
    assert_equal gid, GlobalID.parse(gid_param)
    assert_equal user, gid.find
    assert_equal user, GlobalID::Locator.locate(gid)
    assert_equal user, GlobalID::Locator.locate(gid_param)
  end

  def test_signed_global_id
    user = User.create!(name: "Test Example")
    sgid = user.to_sgid
    sgid_param = sgid.to_param
    assert_equal "test", sgid.app
    assert_equal "BAh7CEkiCGdpZAY6BkVUSSIWZ2lkOi8vdGVzdC9Vc2VyLzEGOwBUSSIMcHVycG9zZQY7AFRJIgxkZWZhdWx0BjsAVEkiD2V4cGlyZXNfYXQGOwBUMA==--13490c0ced36073a6c80577cec2320c2d50b6a31", sgid_param
    assert_equal sgid, SignedGlobalID.parse(sgid_param)
    assert_equal user, sgid.find
    assert_equal user, SignedGlobalID::Locator.locate(sgid)
  end

  def test_universal_attributes
    user = User.create!(name: "Test Example", email: "test@example.com")
    assert_equal({"name" => "Test Example", "email" => "test@example.com"}, user.universal_attributes)
  end

  def test_universal_attributes_with_nils
    user = User.create!(name: "Test Example")
    assert_equal({"name" => "Test Example"}, user.universal_attributes)
  end

  def test_attributes_global_id_default_app
    user = User.create!(name: "Test Example")
    attributes_gid = user.to_attributes_gid
    assert_equal "attributes.universalid", attributes_gid.app
  end

  def test_attributes_global_id_with_nils
    user = User.create!(name: "Test Example")
    attributes_gid = user.to_attributes_gid
    attributes_gid_param = user.to_attributes_gid_param
    new_user_1 = User.new_from_attributes_gid(attributes_gid)
    new_user_2 = User.new_from_attributes_gid(attributes_gid_param)
    assert_equal "Z2lkOi8vYXR0cmlidXRlcy51bml2ZXJzYWxpZC9Vbml2ZXJzYWxJRDo6QXR0cmlidXRlcy9leUp1WVcxbElqb2lWR1Z6ZENCRmVHRnRjR3hsSW4wJTNEJTBB", attributes_gid_param
    assert_equal({"name" => "Test Example"}, attributes_gid.find)
    refute_equal user, new_user_1
    refute_equal user, new_user_2
    refute_equal new_user_1, new_user_2
    assert_equal user.name, new_user_1.name
    assert_equal user.name, new_user_2.name
    assert user.persisted?
    refute new_user_1.persisted?
    refute new_user_2.persisted?
  end

  def test_attributes_global_id
    user = User.create!(name: "Test Example", email: "test@example.com")
    attributes_gid = user.to_attributes_gid
    attributes_gid_param = user.to_attributes_gid_param
    new_user_1 = User.new_from_attributes_gid(attributes_gid)
    new_user_2 = User.new_from_attributes_gid(attributes_gid_param)
    assert_equal "Z2lkOi8vYXR0cmlidXRlcy51bml2ZXJzYWxpZC9Vbml2ZXJzYWxJRDo6QXR0cmlidXRlcy9leUp1WVcxbElqb2lWR1Z6ZENCRmVHRnRjR3hsSWl3aVpXMWhhV3dpT2lKMFpYTjBRR1Y0WVcxd2JHVXUlMEFZMjl0SW4wJTNEJTBB", attributes_gid_param
    assert_equal({"name" => "Test Example", "email" => "test@example.com"}, attributes_gid.find)
    refute_equal user, new_user_1
    refute_equal user, new_user_2
    refute_equal new_user_1, new_user_2
    assert_equal user.name, new_user_1.name
    assert_equal user.name, new_user_2.name
    assert user.persisted?
    refute new_user_1.persisted?
    refute new_user_2.persisted?
  end

  def test_universal_id
    user = User.create!(name: "Test Example", email: "test@example.com")
    attributes_sgid = user.to_attributes_sgid
    attributes_sgid_param = user.to_attributes_sgid_param
    new_user_1 = User.new_from_attributes_sgid(attributes_sgid)
    new_user_2 = User.new_from_attributes_sgid(attributes_sgid_param)
    assert_equal "BAh7CEkiCGdpZAY6BkVUSSIBgWdpZDovL2F0dHJpYnV0ZXMudW5pdmVyc2FsaWQvVW5pdmVyc2FsSUQ6OkF0dHJpYnV0ZXMvZXlKdVlXMWxJam9pVkdWemRDQkZlR0Z0Y0d4bElpd2laVzFoYVd3aU9pSjBaWE4wUUdWNFlXMXdiR1V1JTBBWTI5dEluMCUzRCUwQQY7AFRJIgxwdXJwb3NlBjsAVEkiDGRlZmF1bHQGOwBUSSIPZXhwaXJlc19hdAY7AFQw--9a565f642f442703689b49224d242563e409ddd0", attributes_sgid_param
    assert_equal({"name" => "Test Example", "email" => "test@example.com"}, attributes_sgid.find)
    refute_equal user, new_user_1
    refute_equal user, new_user_2
    refute_equal new_user_1, new_user_2
    assert_equal user.name, new_user_1.name
    assert_equal user.name, new_user_2.name
    assert user.persisted?
    refute new_user_1.persisted?
    refute new_user_2.persisted?
  end
end
