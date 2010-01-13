class Puerto::Building
  # [name, price, slots, vps == group]
  # The production buildings
  INDIGO_PLANT       = ["Indigo plant", 3, 3, 2]
  SMALL_INDIGO_PLANT = ["Small indigo plant", 1, 1, 1]
  SUGAR_MILL         = ["Sugar mill", 4, 3, 2]
  SMALL_SUGAR_MILL   = ["Small sugar mill", 2, 1, 1]
  TOBACCO_STORAGE    = ["Tobacco storage", 5, 3, 3]
  COFFEE_ROASTER     = ["Coffee roaster", 6, 2, 3]

  # The violet buildings
  SMALL_MARKET     = ["Small market", 1, 1, 1]
  HACIENDA         = ["Hacienda", 2, 1, 1]
  CONSTRUCTION_HUT = ["Construction hut", 2, 1, 1]
  SMALL_WAREHOUSE  = ["Small warehouse", 3, 1, 1]
  HOSPICE          = ["Hospice", 4, 1, 2]
  OFFICE           = ["Office", 5, 1, 2]
  LARGE_MARKET     = ["Large market", 5, 1, 2]
  LARGE_WAREHOUSE  = ["Large warehouse", 6, 1, 2]
  FACTORY          = ["Factory", 7, 1, 3]
  UNIVERSITY       = ["Univeristy", 8, 1, 3]
  HARBOR           = ["Harbor", 8, 1, 3]
  WHARF            = ["Wharf", 9, 1, 3]

  # The large buildings
  GUILD_HALL    = ["Guild hall", 10, 1, 4]
  RESIDENCE     = ["Residence", 10, 1, 4]
  FORTRESS      = ["Fortress", 10, 1, 4]
  CUSTOMS_HOUSE = ["Customs house", 10, 1, 4]
  CITY_HALL     = ["City hall", 10, 1, 4]

  def self.available_buildings
    [
      [INDIGO_PLANT[0], 3],
      [SMALL_INDIGO_PLANT[0], 4],
      [SUGAR_MILL[0], 3],
      [SMALL_SUGAR_MILL[0], 4],
      [TOBACCO_STORAGE[0], 3],
      [COFFEE_ROASTER[0], 3],

      [SMALL_MARKET[0], 2],
      [HACIENDA[0], 2],
      [CONSTRUCTION_HUT[0], 2],
      [SMALL_WAREHOUSE[0], 2],
      [HOSPICE[0], 2],
      [OFFICE[0], 2],
      [LARGE_MARKET[0], 2],
      [LARGE_WAREHOUSE[0], 2],
      [FACTORY[0], 2],
      [UNIVERSITY[0], 2],
      [HARBOR[0], 2],
      [WHARF[0], 2],

      [GUILD_HALL[0], 1],
      [RESIDENCE[0], 1],
      [FORTRESS[0], 1],
      [CUSTOMS_HOUSE[0], 1],
      [CITY_HALL[0], 1],
    ].freeze
  end

  def self.buy_building(available, requested)
    building = available.find {|element| element[0]==requested[0] }

    unless building.nil?
      if building[1] > 0
        building[1]-=1
        return building
      else
        return nil
      end
    end
  end

  def initialize(name, price, slots, vps)
  end
end
