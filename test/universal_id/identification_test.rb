# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::IdentificationTest < ActiveSupport::TestCase
  def test_global_id
    User.uncommitted do
      user = User.create!(name: "Test GID")
      gid = user.to_gid

      expected = {
        uri: "gid://UniversalID/User/1",
        param: "Z2lkOi8vVW5pdmVyc2FsSUQvVXNlci8x"
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
      expected = "BAh7CEkiCGdpZAY6BkVUSSIdZ2lkOi8vVW5pdmVyc2FsSUQvVXNlci8xBjsAVEkiDHB1cnBvc2UGOwBUSSIMZGVmYXVsdAY7AFRJIg9leHBpcmVzX2F0BjsAVDA=--87cfc2f7fa5364f7be2d95cea4ddb46e2a36f0ba"

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

  def test_attributes_with_gid
    User.uncommitted do
      expected = {"name" => "Attributes With GID", "email" => "attributes_with_gid@example.com"}
      user = User.create!(expected)
      refute_equal expected, user.attributes
      assert_equal expected, user.attributes_with_gid(block_list: %w[id created_at updated_at])
    end
  end

  def test_attributes_with_gid_with_nils
    User.uncommitted do
      expected = {"name" => "Universal ID Hash Nils"}
      user = User.create!(expected)
      refute_equal expected, user.attributes
      assert_equal expected, user.attributes_with_gid(block_list: %w[id created_at updated_at])
    end
  end

  def test_ugid_with_blanks
    User.uncommitted do
      user = User.create!(name: "Test UGID with Blanks")
      ugid = user.to_ugid(hash_with_gid_options: {block_list: %w[id created_at updated_at]})

      expected = {
        uri: "gid://UniversalID/UniversalID::HashWithGID/eNqrVspLzE1VslIKSS0uUQh193RRKM8syVBwyknMyy5WqgUAqs8KnA",
        param: "Z2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6Okhhc2hXaXRoR0lEL2VOcXJWc3BMekUxVnNsSUtTUzB1VVFoMTkzUlJLTThzeVZCd3lrbk15eTVXcWdVQXFzOEtuQQ",
        hash: {"name" => "Test UGID with Blanks"}
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

  def test_ugid
    User.uncommitted do
      user = User.create!(name: "Test UGID", email: "test@example.com")
      ugid = user.to_ugid(hash_with_gid_options: {block_list: %w[id created_at updated_at]})

      expected = {
        uri: "gid://UniversalID/UniversalID::HashWithGID/eNqrVspLzE1VslIKSS0uUQh193RR0lFKzU3MzAGKlQDFHFIrEnMLclL1kvNzlWoBZq4PlA",
        param: "Z2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6Okhhc2hXaXRoR0lEL2VOcXJWc3BMekUxVnNsSUtTUzB1VVFoMTkzUlIwbEZLelUzTXpBR0tsUURGSEZJckVuTUxjbEwxa3ZOemxXb0JacTRQbEE",
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
      usgid = user.to_usgid(hash_with_gid_options: {block_list: %w[id created_at updated_at]})

      expected = {
        param: "BAh7CEkiCGdpZAY6BkVUSSIBfWdpZDovL1VuaXZlcnNhbElEL1VuaXZlcnNhbElEOjpIYXNoV2l0aEdJRC9lTnFyVnNwTHpFMVZzbElLU1MwdVVRZ05kdmQwVWRKUlNzMU56TXdCQ3BZQUJSMVNLeEp6QzNKUzlaTHpjNVZxQVhZekQtYz9leHBpcmVzX2luBjsAVEkiDHB1cnBvc2UGOwBUSSIMZGVmYXVsdAY7AFRJIg9leHBpcmVzX2F0BjsAVDA=--b10d48fbe830720d6e19da8961ce9c620b4c5718",
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
