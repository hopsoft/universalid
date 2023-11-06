# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::SettingsTest < Minitest::Test
  def test_default_settings
    expected = {
      prepack: {
        exclude: [],
        include: [],
        include_blank: true,

        active_record: {
          exclude_database_keys: false,
          exclude_timestamps: false,
          include_unsaved_changes: false,
          include_loaded_associations: false,
          max_association_depth: 0
        }
      }
    }
    assert_equal expected, UniversalID::Settings.default.to_h
  end

  def test_squish_settings
    refute UniversalID::Settings.squish.prepack.include_blank
  end
end
