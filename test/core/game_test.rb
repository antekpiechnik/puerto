require 'test/test_helper'

class CoreGameTest < Test::Unit::TestCase
  def setup
    @setup = Puerto::Core::Setup.new
    @players = @setup.players = Puerto::Player.create(["Michal", "Antek", "Jan"])
    @michal, @antek, @jan = @setup.players
    @game = Puerto::Core::Game.new(@setup)
  end

  def test_current_player_returns_first_player
    assert_equal @michal, @game.players.current
  end

  def test_unique_goods_names
    goods = [
      Puerto::Core::Game::CORN,
      Puerto::Core::Game::INDIGO,
      Puerto::Core::Game::SUGAR,
      Puerto::Core::Game::TOBACCO,
      Puerto::Core::Game::COFFEE]
    assert_equal goods.size, goods.uniq.size
  end

  def test_to_s_method_for_ships
    ships = [[4, 3, Puerto::Core::Game::COFFEE],
             [5, 0, nil],
             [6, 1, Puerto::Core::Game::TOBACCO]].extend(CargoShipList)
    assert_equal "3/4(c), 0/5, 1/6(t)", ships.to_s
  end

  3.upto(5) do |i|
    define_method("test_correct_ships_for_%dplayer_game" % [i]) do
      names = (1..i).map(&:to_s)
      players = Puerto::Player.create(names)
      setup = Puerto::Core::Setup.new
      setup.players = players
      game = Puerto::Core::Game.new(setup)
      assert_equal [i + 1, i + 2, i + 3], game.cargo_ships.map(&:first)
    end

    define_method("test_correct_vps_for_%dplayer_game" % [i]) do
      names = (1..i).map(&:to_s)
      players = Puerto::Player.create(names)
      setup = Puerto::Core::Setup.new
      setup.players = players
      game = Puerto::Core::Game.new(setup)
      assert_equal({3 => 75, 4 => 100, 5 => 122}[i], game.vps)
    end

    define_method("test_correct_colonists_for_%dplayer_game" % [i]) do
      names = (1..i).map(&:to_s)
      players = Puerto::Player.create(names)
      setup = Puerto::Core::Setup.new
      setup.players = players
      game = Puerto::Core::Game.new(setup)
      assert_equal({3 => 55, 4 => 75, 5 => 95}[i], game.colonists)
    end

    define_method("test_correct_roles_for_%dplayer_game" % [i]) do
      names = (1..i).map(&:to_s)
      players = Puerto::Player.create(names)
      setup = Puerto::Core::Setup.new
      setup.players = players
      game = Puerto::Core::Game.new(setup)
      assert_equal(i + 3, game.roles.size)
    end
  end

  def text_next_returns_true_if_phase_finished
    assert @players.count == 3
    8.times { assert ! @game.next }
    assert @game.next
  end

  def test_choosing_the_role_makes_it_unavailable
    role = @game.roles[1][0]
    assert_not_nil role
    @game.choose_role(role)
    assert_equal false, @game.roles[1][1]
  end

  def test_finishing_round_resets_the_roles
    3.times do |role_index|
      @game.choose_role(@game.roles[role_index][0])
      3.times { @game.next }
    end
    assert_equal true, @game.roles[0][1]
  end

  def test_adding_vps_to_player
    assert_equal 0, @players[0].vps
    @game.award_vps(@players[0], 2)
    assert_equal 2, @players[0].vps
  end

  def test_adding_negative_vps_fails
    assert_equal 0, @players[0].vps
    @game.award_vps(@players[0], -2)
    assert_equal 0, @players[0].vps
  end

  def test_do_award_vps_even_if_not_enough_left
    assert_equal 75, @game.vps
    assert_equal 0, @players[0].vps
    @game.award_vps(@players[0], 76)
    assert_equal 76, @players[0].vps
    assert_equal -1, @game.vps
  end

  def test_adding_vps_decreases_games_vps
    assert_equal 0, @players[0].vps
    assert_equal 75, @game.vps
    @game.award_vps(@players[0], 10)
    assert_equal 10, @players[0].vps
    assert_equal 65, @game.vps
  end

  def test_adding_negative_vps_wont_decrease_games_vps
    assert_equal 75, @game.vps
    @game.award_vps(@players[0], -5)
    assert_equal 75, @game.vps
  end

  def test_game_will_finish_when_no_vps_left
    assert_equal 75, @game.vps
    @game.award_vps(@players[0], 75)
    assert_equal 0, @game.vps
    @game.next
    assert @game.last_phase?
  end

  def test_player_with_highest_vps_wins
    @game.award_vps(@players[0], 40)
    @game.award_vps(@players[1], 30)
    @game.award_vps(@players[2], 5)
    @game.next
    assert_same @game.winner, @players[0]
  end

  def test_if_same_amount_of_vps_then_doubloons_decides_winner
    @game.award_vps(@antek, 50)
    @game.award_vps(@michal, 50)
    @antek.add_doubloons(4)
    @michal.add_doubloons(3)
    assert_equal @antek, @game.winner
  end

  def test_even_if_one_has_more_doubloons_vps_still_decide
    @game.award_vps(@antek, 31)
    @game.award_vps(@michal, 30)
    @antek.add_doubloons(1)
    @michal.add_doubloons(40)
    assert_equal @antek, @game.winner
  end

  def test_each_valid_yields_only_available_roles
    @game.choose_role(Puerto::Core::Game::SETTLER)
    @game.choose_role(Puerto::Core::Game::BUILDER)
    counter = 0
    @game.roles.each { counter += 1 }
    assert_equal 6, counter
    counter = 0
    players = @game.roles.each_valid { counter += 1 }
    assert_equal 4, counter
  end

  def test_each_valid_yields_nice_role_description
    @game.roles[0][2] = 3
    descs = []
    @game.roles.each_valid { |desc, _, _| descs << desc }
    assert_equal "%s (3d)" % [@game.roles[0][0]], descs.first
  end
end
