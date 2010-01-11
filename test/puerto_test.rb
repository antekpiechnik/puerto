require 'test/test_helper'

class PuertoTest < Test::Unit::TestCase
  def test_menu
    p = Puerto.new
    p.handler.handle(:start)
    assert p.handler.is_a?(Setup)
  end
end
