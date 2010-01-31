require 'test/test_helper'

class CoreSetupTest < Test::Unit::TestCase
  def setup
    @setup = Puerto::Core::Setup.new
    @players = Puerto::Player.create(["a", "b", "c"])
  end

  def test_players_returns_true_if_players_set
    assert ! @setup.players?
    @setup.players = @players
    assert @setup.players?
  end

  def test_players_accessor
    @setup.players = @players
    assert_equal @players, @setup.players
  end
end
