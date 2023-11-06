# frozen_string_literal: true

require_relative "../../test_helper"

class UniversalID::Prepacker::ArrayTest < Minitest::Test
  def setup
    @array = [Date.today, nil, "", "          ", "\t", "\r", "\n", "\r\n", "string", true, false, 123, [], [nil, "", "string", true, false, 123], {}, {a: 1}]
    @deep_array = [
      Date.today, nil, "", "          ", "\t", "\r", "\n", "\r\n", "string", true, false, 123, [], [nil, "", "string", true, false, 123], {}, {a: 1},
      [Date.today, nil, "", "          ", "\t", "\r", "\n", "\r\n", "string", true, false, 123, [], [nil, "", "string", true, false, 123], {}, {a: 1},
        [Date.today, nil, "", "          ", "\t", "\r", "\n", "\r\n", "string", true, false, 123, [], [nil, "", "string", true, false, 123], {}, {a: 1},
          [Date.today, nil, "", "          ", "\t", "\r", "\n", "\r\n", "string", true, false, 123, [], [nil, "", "string", true, false, 123], {}, {a: 1}]]]
    ]
  end

  def test_prepack_array_without_config
    prepacked = UniversalID::Prepacker.prepack(@array)
    assert_equal @array, prepacked
  end

  def test_prepack_array_with_default_config
    prepacked = UniversalID::Prepacker.prepack(@array, UniversalID::Settings.default.prepack)
    assert_equal @array, prepacked
  end

  def test_prepack_array_with_squish_config
    prepacked = UniversalID::Prepacker.prepack(@array, UniversalID::Settings.squish)
    expected = [Date.today, "string", true, false, 123, ["string", true, false, 123], {a: 1}]
    assert_equal expected, prepacked
  end

  def test_prepack_deep_array_without_config
    prepacked = UniversalID::Prepacker.prepack(@deep_array)
    assert_equal @deep_array, prepacked
  end

  def test_prepack_deep_array_with_default_config
    prepacked = UniversalID::Prepacker.prepack(@deep_array, UniversalID::Settings.default.prepack)
    assert_equal @deep_array, prepacked
  end

  def test_prepack_deep_array_with_squish_config
    prepacked = UniversalID::Prepacker.prepack(@deep_array, UniversalID::Settings.squish)
    expected = [
      Date.today, "string", true, false, 123, ["string", true, false, 123], {a: 1},
      [Date.today, "string", true, false, 123, ["string", true, false, 123], {a: 1},
        [Date.today, "string", true, false, 123, ["string", true, false, 123], {a: 1},
          [Date.today, "string", true, false, 123, ["string", true, false, 123], {a: 1}]]]
    ]
    assert_equal expected, prepacked
  end

  def test_self_references
    array = Marshal.load(Marshal.dump(@array))
    array << array.dup
    array.last << array.dup

    assert_raises(UniversalID::Prepacker::SelfReferenceError) do
      UniversalID::Prepacker.prepack array
    end
  end
end
