# frozen_string_literal: true

require_relative "../../test_helper"

class URI::UID::ActiveRecordTest < Minitest::Test
  def test_new_model_with_loaded_has_many_associations
    Campaign.test do |campaign|
      Email.test 3 do |emails|
        # verify that nothing is persisted
        refute campaign.persisted?
        emails.each { |email| refute email.persisted? }

        # assign the emails to the campaign
        campaign.emails = emails

        options = {
          include_unsaved_changes: true, # required to support new records
          include_descendants: true,
          descendant_depth: 1
        }
        uid = URI::UID.create(campaign, options)
        decoded = URI::UID.parse(uid.to_s).decode

        # verify that the decoded instance is not persisted
        refute decoded.persisted?
        refute decoded.emails.map(&:persisted?).any?

        # verify that the decoded instance is the same as the original
        # and that everything has been restored to the original state
        assert_equal campaign.attributes, decoded.attributes
        assert_equal campaign.emails.map(&:attributes), decoded.emails.map(&:attributes)
      end
    end
  end

  def test_new_model_with_loaded_has_many_associations_exclude_descendants
    Campaign.test do |campaign|
      Email.test 3 do |emails|
        campaign.emails = emails
        options = {
          include_unsaved_changes: true, # required to support new records
          include_descendants: false,
          descendant_depth: 1
        }
        uid = URI::UID.create(campaign, options)
        decoded = URI::UID.parse(uid.to_s).decode
        assert_equal campaign.attributes, decoded.attributes
        assert decoded.emails.none?
      end
    end
  end

  def test_persisted_model_with_loaded_has_many_associations
    Campaign.test! do |campaign|
      Email.test! 3, campaign: campaign do |emails|
        # verify that everything is persisted
        assert campaign.persisted?
        emails.each { |email| assert email.persisted? }

        # ensure the association is loaded
        campaign.emails.load

        uid = URI::UID.create(campaign, include_descendants: true, descendant_depth: 1)
        decoded = URI::UID.parse(uid.to_s).decode

        # verify that the decoded instance is persisted
        assert decoded.persisted?
        assert decoded.emails.map(&:persisted?).all?

        # verify that the decoded instance is the same as the original
        # and that everything has been restored to the original state
        assert decoded.emails.loaded?
        assert_equal campaign, decoded
        assert_equal campaign.emails, decoded.emails
      end
    end
  end

  def test_persisted_model_with_loaded_has_many_associations_exclude_descendants
    Campaign.test! do |campaign|
      Email.test! 3, campaign: campaign do |emails|
        campaign.emails.load
        uid = URI::UID.create(campaign, descendant_depth: 1) # include_descendants: false (default)
        decoded = URI::UID.parse(uid.to_s).decode
        assert_equal campaign, decoded
        refute decoded.emails.loaded?
      end
    end
  end

  def test_persisted_model_with_loaded_has_many_associations_include_descendants_descendant_depth_0
    Campaign.test! do |campaign|
      Email.test! 3, campaign: campaign do |emails|
        campaign.emails.load
        uid = URI::UID.create(campaign, include_descendants: true) # descendant_depth: 0 (default)
        decoded = URI::UID.parse(uid.to_s).decode
        assert_equal campaign, decoded
        refute decoded.emails.loaded?
      end
    end
  end
end
