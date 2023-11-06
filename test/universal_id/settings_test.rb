# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::SettingsTest < Minitest::Test
  def test_default_settings
    expected = {
      prepack: {
        exclude: [],
        include: [],
        include_blank: true,

        database: {
          include_keys: true,
          include_timestamps: true,
          include_unsaved_changes: false,
          include_descendants: false,
          descendant_depth: 0
        }
      }
    }
    assert_equal expected, UniversalID::Settings.default.to_h
  end

  def test_squish_settings
    refute UniversalID::Settings.squish.prepack.include_blank
  end
end
