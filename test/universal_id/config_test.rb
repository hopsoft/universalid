# frozen_string_literal: true

require_relative "test_helper"

class UniversalID::ConfigTest < Minitest::Test
  def test_message_packer_defaults
    expected = {
      global_id: {
        identification: {
          compact: false,
          prepack_method_name: :attributes,
          filters: [
            /credit_card/i,
            /cvv/i,
            /password/i,
            /private_key/i,
            /social_security/i,
            /ssn/i
          ],
          active_record: {
            keep_changes: false
          }
        }
      }
    }
    assert_equal expected, UniversalID.config.message_packer
  end
end
