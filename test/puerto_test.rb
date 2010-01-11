require 'test/test_helper'

class PuertoTest < Test::Unit::TestCase
  def test_menu
    p = Puerto::Handlers::Puerto.new
    p.handler.handle(:start)
    assert p.handler.is_a?(Puerto::Handlers::Setup)
  end
end
