require 'test/test_helper'

class BuildingTest < Test::Unit::TestCase
  def setup
    @setup = Puerto::Core::Setup.new
    @players = @setup.players = Puerto::Player.create(["Michal", "Antek", "Jan"])
    @game = Puerto::Core::Game.new(@setup)
    @buildings = Puerto::Buildings.new(@game)
  end

  def test_cant_buy_if_doesnt_exist
    fake_building_def = "Fake"
    fake_building = @buildings.buy_building(@players[0], fake_building_def)
    assert_nil fake_building
  end

  def test_buy_building_if_its_there
    assert_equal @players[0].buildings, []
    @buildings.buy_building(@players[0], Puerto::Buildings::GUILD_HALL[0])
    assert_not_nil @players[0].buildings
    assert_not_nil @players[0].buildings.map {|a| a[0]}.index(Puerto::Buildings::GUILD_HALL[0])
  end

  def test_cant_buy_if_there_are_no_more
    @buildings.buy_building(@players[0], Puerto::Buildings::HACIENDA[0])
    @buildings.buy_building(@players[1], Puerto::Buildings::HACIENDA[0])
    assert_nil @buildings.buy_building(@players[2], Puerto::Buildings::HACIENDA[0])
  end
end
