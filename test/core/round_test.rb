require 'test/test_helper'

class CoreRoundTest < Test::Unit::TestCase
  def setup
    @setup = Puerto::Core::Setup.new
    @players = @setup.players = Puerto::Player.create(["Michal", "Antek", "Jan", "Kazimierz"])
    @michal, @antek, @jan, @kazimierz = @setup.players
    @game = Puerto::Core::Game.new(@setup)
  end

  def test_roles_set_moves_to_number_of_players
    round = Puerto::Core::Round.new(@game, Puerto::Core::Game::MAYOR)
    assert ! round.finished?
    round.next
    assert ! round.finished?
    (@players.size - 1).times { round.next }
    assert round.finished?
  end
end