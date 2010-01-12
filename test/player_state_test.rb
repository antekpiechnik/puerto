require 'test/test_helper'

class PlayerStateTest < Test::Unit::TestCase
  def setup
    @main = Puerto::Handlers::Puerto.new
    @setup = Puerto::Handlers::Setup.new
    @players = Puerto::Player::create(["Joe", "John", "Jack"])
    @setup.instance_variable_set(:@players, @players)
    @game = Puerto::Handlers::Game.new(@setup)
    @playerstate = Puerto::Handlers::PlayerState.new(@game)
  end

  def test_current_sees_his_vps
    if @players[0].current?
      screen = @playerstate.player_state(*[@players[0]])
      assert_match /VPs:/, screen
    end
  end

  def test_current_doesnt_see_other_vps
    if @players[0].current?
      screen = @playerstate.player_state(*[@players[1]])
      assert !screen.include?("VPs:")
      screen = @playerstate.player_state(*[@players[2]])
      assert !screen.include?("VPs:")
    end
  end

end

