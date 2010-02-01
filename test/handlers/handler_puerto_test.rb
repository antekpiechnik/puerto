require 'test/test_helper'

class HandlerPuertoTest < Test::Unit::TestCase
  def setup
    @puerto = Puerto::Handlers::Puerto.new
  end

  def test_menu
    @puerto.handler.handle("1")
    assert @puerto.handler.is_a?(Puerto::Handlers::Setup)
  end

  def test_assigning_handler_returns_nil
    assert_nil @puerto.assign_handler(@puerto)
  end
end
