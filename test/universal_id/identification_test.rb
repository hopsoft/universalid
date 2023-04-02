# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::IdentificationTest < ActiveSupport::TestCase
  def test_global_id
    User.uncommitted do
      user = User.create!(name: "Test GID")
      gid = user.to_gid

      expected = {
        uri: "gid://test.universalid/User/1",
        param: "Z2lkOi8vdGVzdC51bml2ZXJzYWxpZC9Vc2VyLzE"
      }

      assert_equal expected[:uri], gid.to_s
      assert_equal expected[:param], gid.to_param
      assert_equal gid, GlobalID.parse(expected[:param])
      assert_equal user, gid.find
      assert_equal user, GlobalID::Locator.locate(expected[:uri])
      assert_equal user, GlobalID::Locator.locate(expected[:param])
    end
  end

  def test_signed_global_id
    User.uncommitted do
      user = User.create!(name: "Test SGID")
      sgid = user.to_sgid
      expected = "BAh7CEkiCGdpZAY6BkVUSSIiZ2lkOi8vdGVzdC51bml2ZXJzYWxpZC9Vc2VyLzEGOwBUSSIMcHVycG9zZQY7AFRJIgxkZWZhdWx0BjsAVEkiD2V4cGlyZXNfYXQGOwBUMA==--c89571799ff59385d2afc05f815451a9ebefcba4"

      assert_equal expected, sgid.to_s
      assert_equal expected, sgid.to_param
      assert_equal user, sgid.find
      assert_equal sgid, SignedGlobalID.parse(expected)
      assert_equal user, SignedGlobalID::Locator.locate(sgid)
    end
  end

  def test_invalid_ugid
    invalid_ugid = SecureRandom.hex
    user = User.new_from_ugid(invalid_ugid)
    refute user.valid?
    assert user.errors[:base].find { |e| e.include? "UniversalID GlobalID not found!" }
  end

  def test_invalid_usgid
    invalid_usgid = SecureRandom.hex
    user = User.new_from_usgid(invalid_usgid)
    refute user.valid?
    assert user.errors[:base].find { |e| e.include? "UniversalID SignedGlobalID not found!" }
  end

  def test_universalid_hash
    User.uncommitted do
      user = User.create!(name: "Universal ID Hash", email: "universalid@hash.com")
      expected = {"name" => "Universal ID Hash", "email" => "universalid@hash.com"}
      assert_equal expected, user.universalid_hash
    end
  end

  def test_universalid_hash_with_nils
    User.uncommitted do
      user = User.create!(name: "Universal ID Hash Nils")
      expected = {"name" => "Universal ID Hash Nils"}
      assert_equal expected, user.universalid_hash
    end
  end

  def test_universalid_hash_global_id_with_nils
    User.uncommitted do
      user = User.create!(name: "Test UGID Nils")
      ugid = user.to_ugid

      expected = {
        uri: "gid://UniversalID/UniversalID::Hash/eNqrVspLzE1VslIKSS0uUQh193RR8MvMKVaqBQBntwf7",
        param: "Z2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6Okhhc2gvZU5xclZzcEx6RTFWc2xJS1NTMHVVUWgxOTNSUjhNdk1LVmFxQlFCbnR3Zjc",
        hash: {"name" => "Test UGID Nils"}
      }

      new_user_1 = User.new_from_ugid(ugid)
      new_user_2 = User.new_from_ugid(expected[:uri])
      new_user_3 = User.new_from_ugid(expected[:param])

      assert_equal expected[:uri], ugid.to_s
      assert_equal expected[:param], ugid.to_param
      assert_equal expected[:hash], ugid.find
      refute_equal user, new_user_1
      refute_equal user, new_user_2
      refute_equal user, new_user_3
      refute_equal new_user_1, new_user_2
      assert_equal user.name, new_user_1.name
      assert_equal user.name, new_user_2.name
      assert_equal user.name, new_user_3.name
      assert user.persisted?
      refute new_user_1.persisted?
      refute new_user_2.persisted?
      refute new_user_3.persisted?
    end
  end

  def test_universalid_hash_global_id
    User.uncommitted do
      user = User.create!(name: "Test UGID", email: "test@example.com")
      ugid = user.to_ugid

      expected = {
        uri: "gid://UniversalID/UniversalID::Hash/eNqrVspLzE1VslIKSS0uUQh193RR0lFKzU3MzAGKlQDFHFIrEnMLclL1kvNzlWoBZq4PlA",
        param: "Z2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6Okhhc2gvZU5xclZzcEx6RTFWc2xJS1NTMHVVUWgxOTNSUjBsRkt6VTNNekFHS2xRREZIRklyRW5NTGNsTDFrdk56bFdvQlpxNFBsQQ",
        hash: {"name" => "Test UGID", "email" => "test@example.com"}
      }

      new_user_1 = User.new_from_ugid(ugid)
      new_user_2 = User.new_from_ugid(expected[:uri])
      new_user_3 = User.new_from_ugid(expected[:param])

      assert_equal expected[:uri], ugid.to_s
      assert_equal expected[:param], ugid.to_param
      assert_equal expected[:hash], ugid.find
      refute_equal user, new_user_1
      refute_equal user, new_user_2
      refute_equal user, new_user_3
      refute_equal new_user_1, new_user_2
      assert_equal user.name, new_user_1.name
      assert_equal user.name, new_user_2.name
      assert_equal user.name, new_user_3.name
      assert user.persisted?
      refute new_user_1.persisted?
      refute new_user_2.persisted?
      refute new_user_3.persisted?
    end
  end

  def test_universalid_hash_signed_global_id
    User.uncommitted do
      user = User.create!(name: "Test USGID", email: "test@example.com")
      usgid = user.to_usgid

      expected = {
        param: "BAh7CEkiCGdpZAY6BkVUSSJ7Z2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6Okhhc2gvZU5xclZzcEx6RTFWc2xJS1NTMHVVUWdOZHZkMFVkSlJTczFOek13QkNwWUFCUjFTS3hKekMzSlM5Wkx6YzVWcUFYWXpELWM_ZXhwaXJlc19pbgY7AFRJIgxwdXJwb3NlBjsAVEkiDGRlZmF1bHQGOwBUSSIPZXhwaXJlc19hdAY7AFQw--d3bb3988178da544a2291262d3be20cae7521598",
        hash: {"name" => "Test USGID", "email" => "test@example.com"}
      }

      new_user_1 = User.new_from_usgid(usgid)
      new_user_2 = User.new_from_usgid(expected[:param])

      assert_equal expected[:param], usgid.to_param
      assert_equal expected[:hash], usgid.find
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
end
