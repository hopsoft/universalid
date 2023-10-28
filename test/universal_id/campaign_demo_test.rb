# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::CampaignDemoTest < ActiveSupport::TestCase
  def test_campaign_demo
    # ........................................................................................................
    # Create a Campaign via multi-step form (wizard) running over HTTP
    # ........................................................................................................

    # Step 1. Assign basic campaign info
    campaign = Campaign.new(name: "Example Campaign", description: "Example Description")
    param = campaign.to_packable.to_gid_param

    # Step 2. Create first email
    campaign = Campaign.from_packable(param)
    campaign.emails << campaign.emails.build(subject: "First Email", body: "Welcome", wait: 1.day)
    param = campaign.to_packable(methods: :emails_attributes).to_gid_param

    # Step 3. Create second email
    campaign = Campaign.from_packable(param)
    campaign.emails << campaign.emails.build(subject: "Second Email", body: "Follow Up", wait: 1.week)
    param = campaign.to_packable(methods: :emails_attributes).to_gid_param

    # Step 4. Create third email
    campaign = Campaign.from_packable(param)
    campaign.emails << campaign.emails.build(subject: "Third Email", body: "Hard Sell", wait: 2.days)
    param = campaign.to_packable(methods: :emails_attributes).to_gid_param

    # Step 5. Configure final details
    campaign = Campaign.from_packable(param)
    campaign.assign_attributes trigger: "Sign Up"
    param = campaign.to_packable(methods: :emails_attributes).to_gid_param

    # Step 6. Review and save
    campaign = Campaign.from_packable(param)
    campaign.save!

    # ........................................................................................................
    # Create a digital product from the Campaign (i.e. template)
    # ........................................................................................................

    # 1. Create a packable digital product from the Campaign .................................................
    #    NOTE: The signed param is a sellable digital product with built in purpose and scarcity!
    campaign = Campaign.first
    packable = debug do
      campaign
        .to_packable(except: [:id, :campaign_id, :created_at, :updated_at], methods: :emails_attributes)
        .to_sgid_param(for: "Promotion 123", expires_in: 30.seconds)
    end

    # 2. Reconstruct the shared template (digital product) ...................................................
    copy = Campaign.from_packable(signed_param, for: "Promotion 123")

    # 3. Let the product expire (wait 30 seconds) ............................................................
    # gid = UniversalID::MarshalableHash.parse_gid(signed_param, for: "Promotion 123")
    invalid_copy = Campaign.from_packable(signed_param, for: "Promotion 123")
  end
end
