# frozen_string_literal: true

require_relative "test_helper"

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
        only: [],
        except: []
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

  def test_to_uid
    expected = "uid://universal_id/universal_id-packable_hash/eNprXlKSWlxyeHlqRWJuQU7q0rLEnNLUZXlAsdSUxiXZqakFYAIAdhkSPA"
    actual = @packable.to_uid(except: %w[created_at updated_at remove]).to_s
    assert_equal expected, actual
  end

  def test_unpack_uid
    uid = @packable.to_uid(except: %w[created_at updated_at remove])
    hash = UniversalID::PackableHash.unpack(uid)
    expected = {
      "test" => true,
      "example" => "value",
      "nested" => {"keep" => "keep"}
    }

    assert hash.is_a?(UniversalID::PackableHash)
    assert_equal expected, hash.to_h
  end

  def test_unpack_uid_string
    uid_string = @packable.to_uid(except: %w[created_at updated_at remove]).to_s
    hash = UniversalID::PackableHash.unpack(uid_string)
    expected = {
      "test" => true,
      "example" => "value",
      "nested" => {"keep" => "keep"}
    }

    assert hash.is_a?(UniversalID::PackableHash)
    assert_equal expected, hash.to_h
  end

  def test_to_global_id_object
    proxy = @packable.to_global_id_object(except: %w[created_at updated_at remove])
    assert proxy.is_a?(UniversalID::Packable::GlobalIDObject)
  end

  def test_unpack_global_id
    gid = @packable.to_global_id_object(except: %w[created_at updated_at remove]).to_gid
    expected = {
      "test" => true,
      "example" => "value",
      "nested" => {"keep" => "keep"}
    }

    assert_equal expected, UniversalID::PackableHash.unpack(gid).to_h
  end
end
