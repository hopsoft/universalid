# frozen_string_literal: true

class URI::UID::ActiveRecordRelationTest < Minitest::Test
  def test_uid_build_and_decode
    Campaign.forge! 5, emails: 3, subject: "Flash Sale 123"
    relation = Campaign.email_subjects_like("Sale")
    relation.load
    relation.map { |c| c.emails.load }

    assert_equal 5, Campaign.count
    assert_equal 15, Email.count
    assert relation.loaded?
    assert relation.map { |c| c.emails.loaded? }.any?

    uri = URI::UID.build(relation).to_s
    uid = URI::UID.parse(uri)
    decoded = uid.decode

    refute decoded.loaded?
    refute decoded.map { |c| c.emails.loaded? }.any?
    assert_equal relation, decoded
    assert_equal relation.to_a, decoded.to_a
  end
end
