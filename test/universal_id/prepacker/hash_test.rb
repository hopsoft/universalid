# frozen_string_literal: true

require_relative "../../test_helper"

class UniversalID::Prepacker::HashTest < Minitest::Test
  def setup
    @hash = {
      one: Date.today,
      two: nil,
      three: "",
      four: "          ",
      five: "\t",
      six: "\r",
      seven: "\n",
      eight: "\r\n",
      nine: "string",
      ten: true,
      eleven: false,
      twelve: 123,
      thirteen: [],
      fourteen: [nil, "", "string", true, false, 123],
      fifteen: {},
      sixteen: {a: 1}
    }
    @deep_hash = Marshal.load(Marshal.dump(@hash))
    @deep_hash[:seventeen] = Marshal.load(Marshal.dump(@deep_hash.dup))
    @deep_hash[:seventeen][:eighteen] = Marshal.load(Marshal.dump(@deep_hash.dup))
  end

  def test_prepack_hash_without_config
    prepacked = UniversalID::Prepacker.prepack(@hash)
    assert_equal @hash, prepacked
  end

  def test_prepack_hash_with_default_config
    prepacked = UniversalID::Prepacker.prepack(@hash, UniversalID::Settings.default.prepack)
    assert_equal @hash, prepacked
  end

  def test_prepack_hash_with_squish_config
    prepacked = UniversalID::Prepacker.prepack(@hash, UniversalID::Settings.squish)
    expected = {
      one: Date.today,
      nine: "string",
      ten: true,
      eleven: false,
      twelve: 123,
      fourteen: ["string", true, false, 123],
      sixteen: {a: 1}
    }
    assert_equal expected, prepacked
  end

  def test_prepack_deep_hash_without_config
    prepacked = UniversalID::Prepacker.prepack(@deep_hash)
    assert_equal @deep_hash, prepacked
  end

  def test_prepack_deep_hash_with_default_config
    prepacked = UniversalID::Prepacker.prepack(@deep_hash, UniversalID::Settings.default.prepack)
    assert_equal @deep_hash, prepacked
  end

  def test_prepack_deep_hash_with_squish_config
    prepacked = UniversalID::Prepacker.prepack(@deep_hash, UniversalID::Settings.squish)
    expected = {
      one: Date.today,
      nine: "string",
      ten: true,
      eleven: false,
      twelve: 123,
      fourteen: ["string", true, false, 123],
      sixteen: {a: 1},
      seventeen: {
        one: Date.today,
        nine: "string",
        ten: true,
        eleven: false,
        twelve: 123,
        fourteen: ["string", true, false, 123],
        sixteen: {a: 1},
        eighteen: {
          one: Date.today,
          nine: "string",
          ten: true,
          eleven: false,
          twelve: 123,
          fourteen: ["string", true, false, 123],
          sixteen: {a: 1},
          seventeen: {
            one: Date.today,
            nine: "string",
            ten: true,
            eleven: false,
            twelve: 123,
            fourteen: ["string", true, false, 123],
            sixteen: {a: 1}
          }
        }
      }
    }
    assert_equal expected, prepacked
  end

  def test_self_references
    hash = Marshal.load(Marshal.dump(@hash))
    hash[:seventeen] = hash.dup
    hash[:seventeen][:eighteen] = hash.dup

    assert_raises(UniversalID::Prepack::SelfReferenceError) do
      UniversalID::Prepacker.prepack hash
    end
  end
end
