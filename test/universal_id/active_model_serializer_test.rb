# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::ActiveModelSerializerTest < ActiveSupport::TestCase
  def setup
    @campaign = Campaign.create!(name: "Example Campaign", description: "Example Description", trigger: "Example Trigger")
    @campaign.emails << @campaign.emails.build(subject: "First Email", body: "Welcome", wait: 1.day)
    @campaign.emails << @campaign.emails.build(subject: "Second Email", body: "Follow Up", wait: 1.week)
    @campaign.emails << @campaign.emails.build(subject: "Third Email", body: "Hard Sell", wait: 2.days)
  end

  def teardown
    @campaign.destroy
  end

  def test_to_portable_hash
    expected = {
      "name" => "Example Campaign",
      "description" => "Example Description",
      "trigger" => "Example Trigger",
      "emails_attributes" => [
        {"subject" => "First Email", "body" => "Welcome", "wait" => 86400},
        {"subject" => "Second Email", "body" => "Follow Up", "wait" => 604800},
        {"subject" => "Third Email", "body" => "Hard Sell", "wait" => 172800}
      ]
    }
    assert_equal expected, @campaign.to_portable_hash
  end

  def test_to_portable_hash_gid
    gid = @campaign.to_portable_hash_gid
    assert gid.is_a?(GlobalID)
    expected = "gid://UniversalID/UniversalID::PortableHash/eNplzsELgjAUx_F_Rd55Bwsx8VpKd40OETHnw17MTbaJhfi_NyFE7DT4ve8HNoLiLUIK2Zu3ncTg6B9OjQIGNVphqHOk1So4rVYGzlDToFndy9_CAFtO0j6481HVO7SQ3kawffVC4bzIyVgXZHPl60rXHz9eUQrtf8Rg4OSrJI7CcGJrV6DQqt7CXEuph-DSLTQOo2RryyeZP3rmfitQyoXuDvuZ3qcvZqlfBg"
    assert_equal expected, gid.to_s
  end

  def test_to_portable_hash_gid_param
    expected = "Z2lkOi8vVW5pdmVyc2FsSUQvVW5pdmVyc2FsSUQ6OlBvcnRhYmxlSGFzaC9lTnBsenNFTGdqQVV4X0ZfUmQ1NUJ3c3g4VnBLZDQwT0VUSG53MTdNVGJhSmhmaV9OeUZFN0RUNHZlOEhOb0xpTFVJSzJadTNuY1RnNkI5T2pRSUdOVnBocUhPazFTbzRyVllHemxEVG9GbmR5OV9DQUZ0TzBqNjQ4MUhWTzdTUTNrYXdmZlZDNGJ6SXlWZ1haSFBsNjByWEh6OWVVUXJ0ZjhSZzRPU3JKSTdDY0dKclY2RFFxdDdDWEV1cGgtRFNMVFFPbzJScnl5ZVpQM3JtZml0UXlvWHVEdnVaM3FjdlpxbGZCZw"
    assert_equal expected, @campaign.to_portable_hash_gid_param
  end

  def test_to_portable_hash_sgid
    sgid = @campaign.to_portable_hash_sgid
    assert sgid.is_a?(SignedGlobalID)
    expected = "eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaEpJZ0lTQVdkcFpEb3ZMMVZ1YVhabGNuTmhiRWxFTDFWdWFYWmxjbk5oYkVsRU9qcFFiM0owWVdKc1pVaGhjMmd2WlU1d2JIcHpSVXhuYWtGVmVGOUdYMUprTlRWQ2QzTjRPRlp3UzJRME1FOUZWRWh1ZHpFM1RWUmlZVXBvWm1sZlRubEdSVGRFVkRSMlpUaElUbTlNYVV4VlNVc3lXblV6Ym1OVVp6WkNPVTlxVVVsSFRsWndhSEZJVDJzeFUyODBjbFpaUjNwc1JGUnZSbTVrZVRsZlEwRkdkRTh3YWpZME9ERklWazgzVTFFemEyRjNabVpXUXpSaWVrbDVWbWRZV2toUWJEWXdjbGhJZWpsbFZWRnlkR1k0VW1jMFQxTnlTa2szUTJOSFNuSldOa1JSY1hRM1ExaEZkWEJvTFVSVFRGUlJUMjh5VW5KNWVXVmFVRE55YldacGRGRjViMWgxUkhaMVdqTnhZM1phY1d4bVFtY0dPZ1pGVkE9PSIsImV4cCI6bnVsbCwicHVyIjoiZGVmYXVsdCJ9fQ==--a3f46d53d60b8f847c6a1b98f81548919ba3f016"
    assert_equal expected, sgid.to_s
  end

  def test_to_portable_hash_sgid_param
    expected = "eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaEpJZ0lTQVdkcFpEb3ZMMVZ1YVhabGNuTmhiRWxFTDFWdWFYWmxjbk5oYkVsRU9qcFFiM0owWVdKc1pVaGhjMmd2WlU1d2JIcHpSVXhuYWtGVmVGOUdYMUprTlRWQ2QzTjRPRlp3UzJRME1FOUZWRWh1ZHpFM1RWUmlZVXBvWm1sZlRubEdSVGRFVkRSMlpUaElUbTlNYVV4VlNVc3lXblV6Ym1OVVp6WkNPVTlxVVVsSFRsWndhSEZJVDJzeFUyODBjbFpaUjNwc1JGUnZSbTVrZVRsZlEwRkdkRTh3YWpZME9ERklWazgzVTFFemEyRjNabVpXUXpSaWVrbDVWbWRZV2toUWJEWXdjbGhJZWpsbFZWRnlkR1k0VW1jMFQxTnlTa2szUTJOSFNuSldOa1JSY1hRM1ExaEZkWEJvTFVSVFRGUlJUMjh5VW5KNWVXVmFVRE55YldacGRGRjViMWgxUkhaMVdqTnhZM1phY1d4bVFtY0dPZ1pGVkE9PSIsImV4cCI6bnVsbCwicHVyIjoiZGVmYXVsdCJ9fQ==--a3f46d53d60b8f847c6a1b98f81548919ba3f016"
    assert_equal expected, @campaign.to_portable_hash_sgid_param
  end

  def test_to_portable_hash_sgid_with_purpose
    sgid = @campaign.to_portable_hash_sgid(gid_options: {for: "Testing"})
    assert sgid.is_a?(SignedGlobalID)
    expected = "eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaEpJZ0lTQVdkcFpEb3ZMMVZ1YVhabGNuTmhiRWxFTDFWdWFYWmxjbk5oYkVsRU9qcFFiM0owWVdKc1pVaGhjMmd2WlU1d2JIcHpSVXhuYWtGVmVGOUdYMUprTlRWQ2QzTjRPRlp3UzJRME1FOUZWRWh1ZHpFM1RWUmlZVXBvWm1sZlRubEdSVGRFVkRSMlpUaElUbTlNYVV4VlNVc3lXblV6Ym1OVVp6WkNPVTlxVVVsSFRsWndhSEZJVDJzeFUyODBjbFpaUjNwc1JGUnZSbTVrZVRsZlEwRkdkRTh3YWpZME9ERklWazgzVTFFemEyRjNabVpXUXpSaWVrbDVWbWRZV2toUWJEWXdjbGhJZWpsbFZWRnlkR1k0VW1jMFQxTnlTa2szUTJOSFNuSldOa1JSY1hRM1ExaEZkWEJvTFVSVFRGUlJUMjh5VW5KNWVXVmFVRE55YldacGRGRjViMWgxUkhaMVdqTnhZM1phY1d4bVFtY0dPZ1pGVkE9PSIsImV4cCI6bnVsbCwicHVyIjoiVGVzdGluZyJ9fQ==--ba2156500a50b8a802d85d60cc8f1941c5e29aa0"
    assert_equal expected, sgid.to_s

    assert_nil UniversalID::PortableHash.parse_gid(expected)
    assert_equal sgid, UniversalID::PortableHash.parse_gid(expected, for: "Testing")

    copy = Campaign.new_from_portable_hash(expected)
    assert copy.invalid?
    assert_nil copy.name
    assert copy.errors[:base].find { |e| e.include?("Invalid or expired UniversalID::PortableHash!") }

    copy = Campaign.new_from_portable_hash(expected, for: "Testing")
    assert copy.valid?
    assert_equal @campaign.name, copy.name
    assert_equal @campaign.to_portable_hash, copy.to_portable_hash
  end

  def test_to_portable_hash_sgid_with_expiration
    param = @campaign.to_portable_hash_sgid_param(gid_options: {expires_in: 0.1.seconds})
    copy = Campaign.new_from_portable_hash(param)
    assert copy.valid?
    assert_equal @campaign.name, copy.name
    assert_equal @campaign.to_portable_hash, copy.to_portable_hash

    sleep 0.1

    copy = Campaign.new_from_portable_hash(param)
    assert copy.invalid?
    assert copy.errors[:base].find { |e| e.include?("Invalid or expired UniversalID::PortableHash!") }
    refute_equal @campaign.name, copy.name
    refute_equal @campaign.to_portable_hash, copy.to_portable_hash
  end

  def test_to_portable_hash_sgid_with_purpose_and_expiration
    param = @campaign.to_portable_hash_sgid_param(gid_options: {for: "Testing", expires_in: 0.1.seconds})

    copy = Campaign.new_from_portable_hash(param)
    assert copy.invalid?
    assert_nil copy.name

    copy = Campaign.new_from_portable_hash(param, for: "Testing")
    assert copy.valid?
    assert_equal @campaign.name, copy.name
    assert_equal @campaign.to_portable_hash, copy.to_portable_hash

    sleep 0.1

    copy = Campaign.new_from_portable_hash(param, for: "Testing")
    assert copy.invalid?
    refute_equal @campaign.name, copy.name
    refute_equal @campaign.to_portable_hash, copy.to_portable_hash
  end

  def test_new_from_portable_hash
    hash = @campaign.to_portable_hash
    copy = Campaign.new_from_portable_hash(hash)
    assert_equal @campaign.to_portable_hash, copy.to_portable_hash
  end

  def test_new_from_portable_hash_gid
    gid = @campaign.to_portable_hash_gid
    copy = Campaign.new_from_portable_hash(gid)
    assert_equal @campaign.to_portable_hash, copy.to_portable_hash
  end

  def test_new_from_portable_hash_gid_param
    param = @campaign.to_portable_hash_gid_param
    copy = Campaign.new_from_portable_hash(param)
    assert_equal @campaign.to_portable_hash, copy.to_portable_hash
  end

  def test_new_from_portable_hash_sgid
    sgid = @campaign.to_portable_hash_sgid
    copy = Campaign.new_from_portable_hash(sgid)
    assert_equal @campaign.to_portable_hash, copy.to_portable_hash
  end

  def test_new_from_portable_hash_sgid_param
    param = @campaign.to_portable_hash_sgid_param
    copy = Campaign.new_from_portable_hash(param)
    assert_equal @campaign.to_portable_hash, copy.to_portable_hash
  end
end
