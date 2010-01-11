require 'test/unit'
require 'lib/puerto'

module TestHelpers
  def assert_custom
    flunk
  end
end

class Test::Unit::TestCase
  include TestHelpers
end
