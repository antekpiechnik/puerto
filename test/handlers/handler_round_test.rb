require 'test/test_helper'

class HandlerRoundTest < Test::Unit::TestCase
  def setup
    @setup = Puerto::Core::Setup.new
    @setup.players = Puerto::Player.create(["a", "b", "c", "d"])
    @game = Puerto::Core::Game.new(@setup)
    @role = Puerto::Core::Game::SETTLER
    @setup = Puerto::Handlers::Round.new(@game, @role)
  end

  def test_menu_responds
    assert_menu(@setup, "0", "Next")
  end

  def test_responds_to_run_with_string
    run = @setup.run
    assert_equal String, run.class
  end

  def test_title
    inc = "Role Settler"
    assert @setup.title.include?(inc), "%p doesn't include %p" % [@setup.title, inc]
  end
end
