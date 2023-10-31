# frozen_string_literal: true

require_relative "test_helper"

class UniversalIDTest < ActiveSupport::TestCase
  def test_config
    expected = {
      app: "uid-test"
    }
    assert_equal expected, UniversalID.config.to_h
  end
end
