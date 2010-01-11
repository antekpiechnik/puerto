require 'test/unit'

module TestHelpers
  def assert_custom
    flunk
  end
end

class Test::Unit::TestCase
  include TestHelpers
end
