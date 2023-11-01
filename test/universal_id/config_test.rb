# frozen_string_literal: true

require_relative "test_helper"

class UniversalID::ConfigTest < Minitest::Test
  def test_encode_defaults
    expected = {active_record: {keep_changes: false}}
    assert_equal expected, UniversalID.config.encode
  end
end
