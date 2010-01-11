require 'test/unit'

module TestHelpers
end

class PuertoTest < Test::Unit::TestCase
  include TestHelpers

  ##
  # Only to get rid of "no-tests specified" warning.
  def test_dummy
    assert true
  end

  def assert_custom
    flunk
  end
end
