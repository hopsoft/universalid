# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::ConfigsTest < Minitest::Test
  def test_default_config
    expected = {
      prepack: {
        exclude: [],
        include: [],
        include_blank: true,

        active_record: {
          base: {
            exclude: [],
            include: [],
            include_blank: true,
            exclude_database_keys: false,
            exclude_timestamps: false,
            include_unsaved_changes: false,
            include_loaded_associations: false,
            max_association_depth: 0
          }
        }
      }
    }
    assert_equal expected, UniversalID::Configs.default.to_h
  end

  def test_compact_config
    refute UniversalID::Configs.squish.prepack.include_blank
  end
end
