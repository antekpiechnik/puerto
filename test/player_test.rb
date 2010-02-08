require 'test/test_helper'

class PlayerTest < Test::Unit::TestCase
  def setup
    @players = Puerto::Player::create(["Joe", "John", "Jack"])
  end

  def test_fail_on_too_many_players
    assert !Puerto::Player::validates_player_no?(2)
    assert !Puerto::Player::validates_player_no?(6)
  end

  def test_validates_four_players
    assert Puerto::Player::validates_player_no?(4)
  end

  def test_validates_uniqueness_of_names
    assert Puerto::Player::validates_name_uniq?(["Joe", "Foo"], "Silly")
  end

  def test_fail_on_identical_name
    assert !Puerto::Player::validates_name_uniq?(["Joe"], "Joe")
  end

  def test_creates_three_named_players
    assert_equal 3, @players.length
    assert_equal "Joe", @players[0].name
  end

  def test_fails_on_two_named_players
    players = Puerto::Player::create(["joe","jack"])
    assert_equal [], players
  end

  def test_players_dont_have_anything_on_start
    @players.each do |player|
      assert_equal 0, player.doubloons
      assert_equal 0, player.vps
    end
  end

  def test_create_loop_players
    p1, p2, p3 = @players
    assert_equal p2, p1.next_player
    assert_equal p3, p2.next_player
    assert_equal p1, p3.next_player
  end

  def test_first_player_becomes_governor
    p1, p2, p3 = @players
    assert p1.governor?
    assert ! p2.governor?
    assert ! p3.governor?
  end

  def test_first_player_becomes_current
    p1, p2, p3 = @players
    assert p1.current?
    assert ! p2.current?
    assert ! p3.current?
  end

  def test_if_last_player_finishes_governor_switches
    p1, p2, p3 = @players
    assert p1.governor?
    9.times { @players.next! }
    assert ! p1.governor?
    assert p2.governor?
    assert ! p3.governor?
  end

  def test_becoming_current_cancels_previous_current
    p1, p2, p3 = @players
    @players.next!
    assert ! p1.current?
    assert p2.current?
  end

  def test_adding_doubloons
    p1 = @players[0]
    p1.add_doubloons(5)
    assert_equal 5, p1.doubloons
  end

  def test_summing_up_doubloons_when_adding
    p1 = @players[0]
    p1.add_doubloons(5)
    p1.add_doubloons(3)
    assert_equal 8, p1.doubloons
  end

  def test_wont_add_negative_doubloons
    p1 = @players[0]
    p1.add_doubloons(-3)
    assert_equal 0, p1.doubloons
  end

  def test_adding_vps
    p1 = @players[0]
    p1.add_vps(1)
    assert_equal 1, p1.vps
  end

  def test_summing_up_vps_when_adding
    p1 = @players[0]
    p1.add_vps(3)
    p1.add_vps(2)
    assert_equal 5, p1.vps
  end

  def test_wont_add_negative_vps
    p1 = @players[0]
    p1.add_vps(-3)
    assert_equal 0, p1.vps
  end

  def test_awarding_buildings
    p1 = @players[0]
    assert_equal p1.buildings.size, 0
    p1.award_building(Puerto::Buildings::HACIENDA[0])
    assert_equal p1.buildings.size, 1
  end

  def test_free_city_space
    p1 = @players[0]
    assert_equal p1.free_city_space, 12
    p1.award_building(Puerto::Buildings::HACIENDA[0])
    assert_equal p1.free_city_space, 11
  end

  def test_adding_colonists
    p1 = @players[0]
    p1.add_colonists(5)
    assert_equal 5, p1.colonists
  end

  def test_summing_up_colonists_when_adding
    p1 = @players[0]
    p1.add_colonists(3)
    p1.add_colonists(5)
    assert_equal 8, p1.colonists
  end
  
  def test_wont_add_negative_colonists
    p1 = @players[0]
    p1.add_colonists(2)
    p1.add_colonists(-1)
    assert_equal 2, p1.colonists
  end

  def test_assigning_colonists_works
    p1 = @players[0]
    p1.award_building(Puerto::Buildings::HACIENDA[0])
    p1.assign_colonist(Puerto::Buildings::HACIENDA[0])
    assert_equal 1, p1.buildings[0][1]
  end

  def test_assigning_colonists_when_no_building
    p1 = @players[0]
    assert_nil p1.assign_colonist(Puerto::Buildings::HACIENDA[0])
  end

  def test_print_inactive_buildings_without_colonists
    p1 = @players[0]
    p1.award_building(Puerto::Buildings::HACIENDA[0])
    assert p1.buildings_pretty_print.include?("Hacienda (inactive)")
  end

  def test_prints_active_and_inactive
    p1 = @players[0]
    p1.award_building(Puerto::Buildings::INDIGO_PLANT[0])
    p1.award_building(Puerto::Buildings::HACIENDA[0])
    p1.assign_colonist(Puerto::Buildings::HACIENDA[0])
    assert p1.buildings_pretty_print.include?("Hacienda (active)")
    assert p1.buildings_pretty_print.include?("Indigo plant (inactive)")
  end

  def test_adding_goods_works
    p1 = @players[0]
    if p1.goods.map {|a| a[0]}.include?(Puerto::Core::Game::CORN)
      p1.remove_good(Puerto::Core::Game::CORN)
    end
    p1.add_goods(Puerto::Core::Game::CORN, 10)
    assert p1.goods.include?([Puerto::Core::Game::CORN, 10])
  end

  def test_summing_goods_works
    p1 = @players[0]
    if p1.goods.map {|a| a[0]}.include?(Puerto::Core::Game::CORN)
      p1.remove_good(Puerto::Core::Game::CORN)
    end
    p1.add_goods(Puerto::Core::Game::CORN, 10)
    p1.add_goods(Puerto::Core::Game::CORN, 11)
    assert p1.goods.include?([Puerto::Core::Game::CORN, 21])
  end

  def test_goods_pretty_print
    p1 = @players[0]
    if p1.goods.map {|a| a[0]}.include?(Puerto::Core::Game::CORN)
      p1.remove_good(Puerto::Core::Game::CORN)
    end
    p1.add_goods(Puerto::Core::Game::CORN, 10)
    assert p1.goods_pretty_print.include?("Corn - 10")
  end
end
