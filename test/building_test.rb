require 'test/test_helper'

class BuildingTest < Test::Unit::TestCase
  def setup
    @buildings = Puerto::Building.available_buildings.dup
  end

  def test_cant_buy_if_doesnt_exist
    fake_building_def = ["Fake", 0, 0, 0]
    fake_building = Puerto::Building.buy_building(@buildings, fake_building_def)
    assert_nil fake_building
  end

  def test_buy_building_if_its_there
    building = Puerto::Building.buy_building(@buildings, Puerto::Building::GUILD_HALL)
    assert_not_nil building
    assert_equal building[0], Puerto::Building::GUILD_HALL[0]
  end

  def test_cant_buy_if_there_are_no_more
    building1 = Puerto::Building.buy_building(@buildings, Puerto::Building::GUILD_HALL)
    building2 = Puerto::Building.buy_building(@buildings, Puerto::Building::GUILD_HALL)
    assert_not_nil building1
    assert_nil building2
  end
end
