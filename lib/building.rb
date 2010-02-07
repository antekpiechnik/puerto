Puerto::Building = Struct.new(:name, :price, :slots, :vps)

class Puerto::Buildings
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

  AVAILABLE_BUILDINGS =
    [
      INDIGO_PLANT, INDIGO_PLANT, INDIGO_PLANT,
      SMALL_INDIGO_PLANT, SMALL_INDIGO_PLANT, SMALL_INDIGO_PLANT, SMALL_INDIGO_PLANT,
      SUGAR_MILL, SUGAR_MILL, SUGAR_MILL,
      SMALL_SUGAR_MILL, SMALL_SUGAR_MILL, SMALL_SUGAR_MILL, SMALL_SUGAR_MILL,
      TOBACCO_STORAGE, TOBACCO_STORAGE, TOBACCO_STORAGE,
      COFFEE_ROASTER, COFFEE_ROASTER, COFFEE_ROASTER,

      SMALL_MARKET, SMALL_MARKET,
      HACIENDA, HACIENDA,
      CONSTRUCTION_HUT, CONSTRUCTION_HUT,
      SMALL_WAREHOUSE, SMALL_WAREHOUSE,
      HOSPICE, HOSPICE,
      OFFICE, OFFICE,
      LARGE_MARKET, LARGE_MARKET,
      LARGE_WAREHOUSE, LARGE_WAREHOUSE,
      FACTORY, FACTORY,
      UNIVERSITY, UNIVERSITY,
      HARBOR, HARBOR,
      WHARF, WHARF,

      GUILD_HALL,
      RESIDENCE,
      FORTRESS,
      CUSTOMS_HOUSE,
      CITY_HALL,
    ].map { |e| Puerto::Building.new(*e) }.freeze

  attr_reader :buildings

  def initialize(game)
    @game = game
    @buildings = AVAILABLE_BUILDINGS.dup
  end

  def buy_building(player, name)
    raise ArgumentError.new("Player cannot buy this building") if player.buildings.include?(name)
    idx = buildings.map { |b| b[0] }.index(name)
    player.award_building(name)
    idx ? buildings.delete_at(idx) : nil
  end

  def price(player, building, chosen)
    building.price - discount(player, building, chosen)
  end

  def discount(player, building, chosen)
    sub = chosen ? 1 : 0
    sub += [player.quarry_count, building.vps].min
    sub > building.price ? building.price : sub
  end

  def to_s(player, chosen)
    compact = compacted_buildings
    compacted_buildings.map do |num, building, count|
      price = price(player, building, chosen)
      "%2d. %dx %s %ds     %dd - %dd = %dd" % [num, count, building.name.ljust(20),
        building.slots, building.price, building.price - price, price]
    end.join("\n")
  end

  def compacted_buildings
    out = []
    dup_buildings = buildings.dup
    i = 0
    while not dup_buildings.empty?
      size = dup_buildings.size
      b = dup_buildings.delete(dup_buildings.first)
      out << [i += 1, b, size - dup_buildings.size]
    end
    out
  end
end
