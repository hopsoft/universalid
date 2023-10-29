# frozen_string_literal: true

require_relative "../test_helper"

class UniversalID::PackableHashTest < ActiveSupport::TestCase
  def setup
    @hash = {
      test: true,
      example: "value",
      other: nil,
      created_at: Time.current,
      updated_at: Time.current,
      nested: {
        keep: "keep",
        remove: "remove"
      }
    }
    @packable = UniversalID::PackableHash.new(@hash)
  end

  def test_config
    expected = {
      to_packable_options: {
        allow_blank: false,
        only: [], # keys to include (trumps except)
        except: [] # keys to exclude
      }
    }

    assert expected, UniversalID::PackableHash.config
  end

  def test_marshalable_hash
    assert @hash, @packable.to_h
  end

  def test_pack
    expected = "eNprXlKSWlxyeHlqRWJuQU7q0rLEnNLUZXlAsdSUxiXZqakFYAIAdhkSPA"
    actual = @packable.pack(except: %w[created_at updated_at remove])
    assert_equal expected, actual
  end

  def test_unpack
    packed = @packable.pack(except: %w[created_at updated_at remove])
    hash = UniversalID::PackableHash.unpack(packed)
    expected = {
      "test" => true,
      "example" => "value",
      "nested" => {"keep" => "keep"}
    }

    assert hash.is_a?(UniversalID::PackableHash)
    assert_equal expected, hash.to_h
  end

  def test_to_uri
    expected = "uid://universal_id/universal_id-packable_hash/eNprXlKSWlxyeHlqRWJuQU7q0rLEnNLUZXlAsdSUxiXZqakFYAIAdhkSPA"
    actual = @packable.to_uri(except: %w[created_at updated_at remove]).to_s
    assert_equal expected, actual
  end

  def test_unpack_uri
    uri = @packable.to_uri(except: %w[created_at updated_at remove])
    hash = UniversalID::PackableHash.unpack(uri)
    expected = {
      "test" => true,
      "example" => "value",
      "nested" => {"keep" => "keep"}
    }

    assert hash.is_a?(UniversalID::PackableHash)
    assert_equal expected, hash.to_h
  end
end
