require 'test/test_helper'

class PlayerTest < Test::Unit::TestCase
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
    @players = Puerto::Player::create(["Joe", "John", "Jack"])
    assert_equal 3, @players.length
    assert_equal "Joe", @players[0].name
  end

  def test_fails_on_two_named_players
    @players = Puerto::Player::create(["joe","jack"])
    assert_equal [], @players
  end

  def test_players_dont_have_anything_on_start
    @players = Puerto::Player::create(["Joe", "John", "Jack"])
    @players.each do |player|
      assert_equal 0, player.doubloons
      assert_equal 0, player.vp
    end
  end
end
