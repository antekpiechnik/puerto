require 'test/test_helper'

class CoreRoundTest < Test::Unit::TestCase
  def setup
    @setup = Puerto::Core::Setup.new
    @players = @setup.players = Puerto::Player.create(["Michal", "Antek", "Jan", "Kazimierz"])
    @michal, @antek, @jan, @kazimierz = @setup.players
    @game = Puerto::Core::Game.new(@setup)
  end

  def test_roles_set_moves_to_number_of_players
    round = Puerto::Core::Round.new(@game, Puerto::Core::Game::SETTLER)
    assert ! round.finished?
    round.next
    assert ! round.finished?
    (@players.size - 1).times { round.next }
    assert round.finished?
  end

  def test_prospector_gets_one_doubloon
    round = Puerto::Core::Round.new(@game, Puerto::Core::Game::PROSPECTOR)
    round.next
    assert_equal 1, @michal.doubloons
  end

  def test_prospector_doesnt_award_other_players
    round = Puerto::Core::Round.new(@game, Puerto::Core::Game::PROSPECTOR)
    round.next
    round.next
    assert_equal 0, @antek.doubloons
    round.next
    assert_equal 0, @jan.doubloons
    round.next
    assert_equal 0, @kazimierz.doubloons
  end
end
