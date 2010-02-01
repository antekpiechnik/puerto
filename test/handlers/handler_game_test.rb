require 'test/test_helper'

class HandlerGameTest < Test::Unit::TestCase
  def setup
    @setup = Puerto::Core::Setup.new
    @setup.players = Puerto::Player.create(["a", "b", "c"])
    @game = Puerto::Handlers::Game.new(@setup)
  end

  def test_menu_responds
    assert_menu(@game, "1", "Show player stats")
    assert_menu(@game, "2", "Show game stats")
    assert_menu(@game, "0", "End game")
  end

  def test_responds_to_run_with_string
    run = @game.run
    assert_equal String, run.class
  end

  def test_title
    assert_equal "3-player game", @game.title
  end
end
