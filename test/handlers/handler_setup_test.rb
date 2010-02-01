require 'test/test_helper'

class HandlerSetupTest < Test::Unit::TestCase
  def setup
    @setup = Puerto::Handlers::Setup.new
  end

  def test_menu_responds
    assert_menu(@setup, "1", "Set players")
    assert_menu(@setup, "2", "Start game")
    assert_menu(@setup, "0", "Back to main")
  end

  def test_responds_to_run_with_string
    run = @setup.run
    assert_equal String, run.class
  end

  def test_title
    assert_equal "Setup", @setup.title
  end
end
