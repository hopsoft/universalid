# frozen_string_literal: true

require_relative "test_helper"

class UniversalID::PackableHashTest < ActiveSupport::TestCase
  def test_default_pack_options
    expected = {
      to_packable_options: {
        allow_blank: false,
        only: [],
        except: []
      }
    }

    assert expected, UniversalID::PackableHash.default_pack_options
  end
end
