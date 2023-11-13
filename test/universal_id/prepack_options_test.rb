# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::PrepackOptionsTest < Minitest::Test
  def test_new
    options = UniversalID::PrepackOptions.new
    expected = {
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
    assert_equal expected, options.to_h
    assert_equal UniversalID::Settings.default.prepack.to_h, options.to_h
  end

  def test_new_with_override
    options = UniversalID::PrepackOptions.new(exclude: [:created_at, :updated_at], include_blank: false)
    expected = {
      exclude: [
        :created_at,
        :updated_at
      ],
      include: [],
      include_blank: false,
      database: {
        include_keys: true,
        include_timestamps: true,
        include_unsaved_changes: false,
        include_descendants: false,
        descendant_depth: 0
      }
    }
    assert_equal expected, options.to_h
    assert options.reject_key?(:created_at)
    assert options.reject_key?("created_at")
    assert options.reject_value?(nil)
    assert options.reject_value?([])
    assert options.reject_value?({})
  end

  def test_new_database_options
    options = UniversalID::PrepackOptions.new
    expected = {
      include_keys: true,
      include_timestamps: true,
      include_unsaved_changes: false,
      include_descendants: false,
      descendant_depth: 0
    }
    assert_equal expected, options.database_options.to_h
  end

  def test_new_database_options_with_override
    options = UniversalID::PrepackOptions.new(include_keys: false, include_timestamps: false)
    expected = {
      include_keys: false,
      include_timestamps: false,
      include_unsaved_changes: false,
      include_descendants: false,
      descendant_depth: 0
    }
    assert_equal expected, options.database_options.to_h
  end
end
