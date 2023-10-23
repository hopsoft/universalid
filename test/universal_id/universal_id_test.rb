# frozen_string_literal: true

require_relative "../test_helper"

class UniversalIDTest < ActiveSupport::TestCase
  def test_config
    expected = {
      packable_hash: {
        allow_blank: false,
        only: [],
        except: []
      }
    }
    assert_equal expected, UniversalID.config.to_h
  end
end
