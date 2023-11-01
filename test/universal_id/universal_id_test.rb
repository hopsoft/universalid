# frozen_string_literal: true

require_relative "test_helper"

class UniversalIDTest < ActiveSupport::TestCase
  def test_config
    expected = {
      app: "universal-id--test-suite",
      encode: {
        active_record: {
          keep_changes: false
        }
      }
    }
    assert_equal expected, UniversalID.config.to_h.except(:logger)
  end
end
