# frozen_string_literal: true

class URI::UIDTest < Minitest::Test
  def test_from_payload
    expected = scalars
    payload = URI::UID.build(expected).payload
    actual = URI::UID.from_payload(payload).decode
    assert_equal expected, actual
  end
end
