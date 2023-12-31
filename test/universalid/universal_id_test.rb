# frozen_string_literal: true

class UniversalID::UniversalIDTest < Minitest::Test
  def test_uid_to_gid_back_to_uid
    campaign = Campaign.create_for_test emails: 3, attachments: 2

    uid = URI::UID.build(campaign)
    gid_param = uid.to_gid_param

    parsed_gid = GlobalID.parse(gid_param)
    parsed_uid = parsed_gid.find.uid

    parsed_campaign = parsed_uid.decode

    assert_equal campaign, parsed_campaign
    assert_equal campaign.emails, parsed_campaign.emails
    assert_equal campaign.emails.map(&:attachments), parsed_campaign.emails.map(&:attachments)
    assert parsed_campaign.emails.loaded?
    assert parsed_campaign.emails.map(&:attachments).map(&:loaded)
  end

  def test_uid_to_sgid_back_to_uid
    campaign = Campaign.create_for_test emails: 3, attachments: 2

    uid = URI::UID.build(campaign)
    gid_param = uid.to_sgid_param

    parsed_gid = SignedGlobalID.parse(gid_param)
    parsed_uid = parsed_gid.find.uid

    parsed_campaign = parsed_uid.decode

    assert_equal campaign, parsed_campaign
    assert_equal campaign.emails, parsed_campaign.emails
    assert_equal campaign.emails.map(&:attachments), parsed_campaign.emails.map(&:attachments)
    assert parsed_campaign.emails.loaded?
    assert parsed_campaign.emails.map(&:attachments).map(&:loaded)
  end
end
