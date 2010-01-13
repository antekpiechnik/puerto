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

  def test_unique_goods_names
    goods = [
      Puerto::Handlers::Game::CORN,
      Puerto::Handlers::Game::INDIGO,
      Puerto::Handlers::Game::SUGAR,
      Puerto::Handlers::Game::TOBACCO,
      Puerto::Handlers::Game::COFFEE]
    assert_equal goods.size, goods.uniq.size
  end

  def test_nice_output_for_ships
    ships = [[4, 3, Puerto::Handlers::Game::COFFEE],
             [5, 0, nil],
             [6, 1, Puerto::Handlers::Game::TOBACCO]].extend(CargoShipList)
    assert_equal "3/4(c), 0/5, 1/6(t)", ships.to_s
  end

  3.upto(5) do |i|
    define_method("test_correct_ships_for_%dplayer_game" % [i]) do
      names = (1..i).map(&:to_s)
      players = Puerto::Player.create(names)
      setup = Puerto::Handlers::Setup.new
      setup.instance_variable_set(:@players, players)
      game = Puerto::Handlers::Game.new(setup)
      assert_equal [i + 1, i + 2, i + 3], game.cargo_ships.map(&:first)
    end

    define_method("test_correct_vps_for_%dplayer_game" % [i]) do
      names = (1..i).map(&:to_s)
      players = Puerto::Player.create(names)
      setup = Puerto::Handlers::Setup.new
      setup.instance_variable_set(:@players, players)
      game = Puerto::Handlers::Game.new(setup)
      assert_equal({3 => 75, 4 => 100, 5 => 122}[i], game.vps)
    end

    define_method("test_correct_colonists_for_%dplayer_game" % [i]) do
      names = (1..i).map(&:to_s)
      players = Puerto::Player.create(names)
      setup = Puerto::Handlers::Setup.new
      setup.instance_variable_set(:@players, players)
      game = Puerto::Handlers::Game.new(setup)
      assert_equal({3 => 55, 4 => 75, 5 => 95}[i], game.colonists)
    end
  end
end
