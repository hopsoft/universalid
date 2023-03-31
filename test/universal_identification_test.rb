# frozen_string_literal: true

require_relative "test_helper"
require_relative "models/user"

class UniversalIdentificationTest < ActiveSupport::TestCase
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

  def test_universal_attributes_global_id_default_app
    user = User.create!(name: "Test Example")
    ugid = user.to_ugid
    assert_equal "attributes.universalid", ugid.app
  end

  def test_universal_attributes_global_id_with_nils
    user = User.create!(name: "Test Example")
    ugid = user.to_ugid
    ugid_param = user.to_ugid_param
    new_user_1 = User.new_from_ugid(ugid)
    new_user_2 = User.new_from_ugid(ugid_param)
    assert_equal "Z2lkOi8vYXR0cmlidXRlcy51bml2ZXJzYWxpZC9Vbml2ZXJzYWxJRDo6QXR0cmlidXRlcy9lTnFyVnNwTHpFMVZzbElLU1MwdVVYQ3RTTXd0eUVsVnFnVUFYRVlINkE", ugid_param
    assert_equal({"name" => "Test Example"}, ugid.find)
    refute_equal user, new_user_1
    refute_equal user, new_user_2
    refute_equal new_user_1, new_user_2
    assert_equal user.name, new_user_1.name
    assert_equal user.name, new_user_2.name
    assert user.persisted?
    refute new_user_1.persisted?
    refute new_user_2.persisted?
  end

  def test_universal_attributes_global_id
    user = User.create!(name: "Test Example", email: "test@example.com")
    ugid = user.to_ugid
    ugid_param = user.to_ugid_param
    new_user_1 = User.new_from_universal_attributes_gid(ugid)
    new_user_2 = User.new_from_universal_attributes_gid(ugid_param)
    assert_equal "Z2lkOi8vYXR0cmlidXRlcy51bml2ZXJzYWxpZC9Vbml2ZXJzYWxJRDo6QXR0cmlidXRlcy9lTnFyVnNwTHpFMVZzbElLU1MwdVVYQ3RTTXd0eUVsVjBsRkt6VTNNekFFS2x3Q0ZIVklod25ySi1ibEt0UUNyZGhFMw", ugid_param
    assert_equal({"name" => "Test Example", "email" => "test@example.com"}, ugid.find)
    refute_equal user, new_user_1
    refute_equal user, new_user_2
    refute_equal new_user_1, new_user_2
    assert_equal user.name, new_user_1.name
    assert_equal user.name, new_user_2.name
    assert user.persisted?
    refute new_user_1.persisted?
    refute new_user_2.persisted?
  end

  def test_universal_attributes_signed_global_id
    user = User.create!(name: "Test Example", email: "test@example.com")
    usgid = user.to_usgid
    usgid_param = user.to_usgid_param
    new_user_1 = User.new_from_universal_attributes_sgid(usgid)
    new_user_2 = User.new_from_universal_attributes_sgid(usgid_param)
    assert_equal "BAh7CEkiCGdpZAY6BkVUSSJ-Z2lkOi8vYXR0cmlidXRlcy51bml2ZXJzYWxpZC9Vbml2ZXJzYWxJRDo6QXR0cmlidXRlcy9lTnFyVnNwTHpFMVZzbElLU1MwdVVYQ3RTTXd0eUVsVjBsRkt6VTNNekFFS2x3Q0ZIVklod25ySi1ibEt0UUNyZGhFMwY7AFRJIgxwdXJwb3NlBjsAVEkiDGRlZmF1bHQGOwBUSSIPZXhwaXJlc19hdAY7AFQw--a838a876108304673f35dba2d29f39dd28e9c41c", usgid_param
    assert_equal({"name" => "Test Example", "email" => "test@example.com"}, usgid.find)
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
