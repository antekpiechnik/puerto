require 'test/test_helper'

class PlayerStateTest < Test::Unit::TestCase
  def setup
    @main = Puerto::Handlers::Puerto.new
    @setup = Puerto::Core::Setup.new
    @players = Puerto::Player::create(["Joe", "John", "Jack"])
    @setup.players = @players
    @game = Puerto::Handlers::Game.new(@setup)
    @playerstate = Puerto::Handlers::PlayerState.new(@game)
  end

  def test_current_sees_his_vps
    assert @players[0].current?
    screen = @playerstate.player_state(*[@players[0]])
    assert_match /VPs/, screen
  end

  def test_current_doesnt_see_other_vps
    assert @players[0].current?
    screen = @playerstate.player_state(*[@players[1]])
    assert !screen.include?("VPs")
    screen = @playerstate.player_state(*[@players[2]])
    assert !screen.include?("VPs")
  end

  def test_current_sees_all_doubloons
    @players[1].add_doubloons(3)
    assert @players[0].current?
    screen = @playerstate.player_state(*[@players[1]])
    assert screen.include?("Doubloons : %d" % @players[1].doubloons)
  end

  def test_current_sees_his_doubloons
    @players[0].add_doubloons(5)
    assert @players[0].current?
    screen = @playerstate.player_state(*[@players[0]])
    assert screen.include?("Doubloons : %d" % @players[0].doubloons)
  end
end
