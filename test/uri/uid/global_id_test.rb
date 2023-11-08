# frozen_string_literal: true

require_relative "../../test_helper"

class URI::UID::GlobalIDTest < Minitest::Test
  def test_changed_persisted_model_with_prepack_options
    Campaign.test! do |campaign|
      campaign.description = "Changed Description"

      # SEE: config/defaults.yml
      prepack_options = {
        include_blank: false,
        include_unsaved_changes: true,
        include_timestamps: false
      }
      uid = URI::UID.create(campaign, prepack_options)
      gid = uid.to_global_id

      assert_equal uid, gid.find.uid
      assert_equal campaign, uid.decode
      assert_equal campaign, gid.find.uid.decode
      assert_equal campaign.description, gid.find.uid.decode.description
    end
  end
end
