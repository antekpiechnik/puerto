require 'test/test_helper'

class GameTest < Test::Unit::TestCase
  def setup
    @main = Puerto::Handlers::Puerto.new
    @setup = Puerto::Handlers::Setup.new
    @players = Puerto::Player.create(["a", "b", "c"])
    @setup.instance_variable_set(:@players, @players)
    @game = Puerto::Handlers::Game.new(@setup)
  end

  def test_current_players_returns_current_player
    assert_equal @game.current_player, @players.first
  end
end
