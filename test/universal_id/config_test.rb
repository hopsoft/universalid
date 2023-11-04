# frozen_string_literal: true

require_relative "test_helper"

class UniversalID::ConfigTest < Minitest::Test
  def test_message_pack_global_id_config
    UniversalID.config.message_pack.global_id.tap do |c|
      assert_equal true, c.include_blank
      assert_equal "to_h", c.prepack_method
      assert_equal [], c.include
      assert_equal [], c.exclude
    end
  end

  def test_message_pack_active_record_config
    UniversalID.config.message_pack.active_record.tap do |c|
      assert_equal true, c.include_blank
      assert_equal [], c.include
      assert_equal [], c.exclude
      assert_equal false, c.preserve_unsaved_changes
      assert_equal false, c.include_loaded_associations
      assert_equal 0, c.max_association_depth
    end
  end
end
