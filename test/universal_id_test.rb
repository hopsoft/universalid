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
        t.timestamps
      end
    end
  end

  def test_global_id
    user = User.create!(name: "example")
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
    user = User.create!(name: "example")
    sgid = user.to_sgid
    sgid_param = sgid.to_param
    assert_equal "test", sgid.app
    assert_equal "BAh7CEkiCGdpZAY6BkVUSSIWZ2lkOi8vdGVzdC9Vc2VyLzEGOwBUSSIMcHVycG9zZQY7AFRJIgxkZWZhdWx0BjsAVEkiD2V4cGlyZXNfYXQGOwBUMA==--13490c0ced36073a6c80577cec2320c2d50b6a31", sgid_param
    assert_equal sgid, SignedGlobalID.parse(sgid_param)
    assert_equal user, sgid.find
    assert_equal user, SignedGlobalID::Locator.locate(sgid)
  end

  def test_universal_id
    user = User.create!(name: "example")
    uid = user.to_uid
    uid_param = uid.to_param
    new_user_1 = User.new_from_uid(uid)
    new_user_2 = User.new_from_uid(uid_param)
    assert_equal "uid", uid.app
    assert_equal "Z2lkOi8vdWlkL1VuaXZlcnNhbElEL2V5SnVZVzFsSWpvaVpYaGhiWEJzWlNKOSUwQQ", uid_param
    assert_equal({"name" => "example"}, uid.find.attributes)
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
    user = User.create!(name: "example")
    suid = user.to_suid
    suid_param = suid.to_param
    new_user_1 = User.new_from_suid(suid)
    new_user_2 = User.new_from_suid(suid_param)
    assert_equal "uid", suid.app
    assert_equal "BAh7CEkiCGdpZAY6BkVUSSI2Z2lkOi8vdWlkL1VuaXZlcnNhbElEL2V5SnVZVzFsSWpvaVpYaGhiWEJzWlNKOSUwQQY7AFRJIgxwdXJwb3NlBjsAVEkiDGRlZmF1bHQGOwBUSSIPZXhwaXJlc19hdAY7AFQw--de9c2472edfd4ffffc8c650f1d5facbd01b8c50f", suid_param
    assert_equal({"name" => "example"}, suid.find.attributes)
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
