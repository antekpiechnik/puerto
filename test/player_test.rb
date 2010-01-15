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
    #@players = Puerto::Player::create(["Joe", "John", "Jack"])
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

  def test_if_last_player_finishes_governor_switches
    p1, p2, p3 = @players
    assert p1.governor?
    3.times { @players.next! }
    assert ! p1.governor?
    assert p2.governor?
  end

  def test_hasnt_acted_as_governor_on_start
    p1, p2, p3 = @players
    assert p1.governor?
    assert ! p1.acted_as_governor
  end

  def test_has_acted_as_governor_before_next_player
    p1, p2, p3 = @players
    assert ! p1.acted_as_governor
    @players.next!
    assert p1.acted_as_governor
  end


  def test_becoming_governor_cancels_previous_current
    p1, p2, p3 = @players
    p1.next!
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
end
