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

  def test_75vps_for_3player_game
    assert_equal 75, @game.vps
  end

  def test_100vps_for_4player_game
    players = Puerto::Player.create(["a", "b", "c", "d"])
    setup = Puerto::Handlers::Setup.new
    setup.instance_variable_set(:@players, players)
    game = Puerto::Handlers::Game.new(setup)
    assert_equal 100, game.vps
  end

  def test_122vps_for_5player_game
    players = Puerto::Player.create(["a", "b", "c", "d", "e"])
    setup = Puerto::Handlers::Setup.new
    setup.instance_variable_set(:@players, players)
    game = Puerto::Handlers::Game.new(setup)
    assert_equal 122, game.vps
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
    ships = [[4, 3, Puerto::Handlers::Game::COFFEE], [5, 0, nil], [6, 0, nil]].extend(CargoShipList)
    assert_equal "3/4(c), 0/5, 0/6", ships.to_s
  end
end
