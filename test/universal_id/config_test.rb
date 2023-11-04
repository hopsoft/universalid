# frozen_string_literal: true

require_relative "test_helper"

class UniversalID::ConfigTest < Minitest::Test
  def test_default_config
    expected = UniversalID.config.to_h.with_indifferent_access
    actual = YAML.safe_load_file(UniversalID::DEFAULT_CONFIG_PATH, aliases: true).with_indifferent_access
    assert_equal expected, actual
  end

  def test_compact_config
    assert UniversalID.config.message_pack.include_blank
    refute UniversalID.compact_config.message_pack.include_blank
  end
end
