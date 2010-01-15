class Puerto::Core::Game
  attr_reader :vps, :cargo_ships, :colonists, :roles, :trading_house, :buildings, :goods, :cargo_ships

  CORN    = "k"
  INDIGO  = "i"
  SUGAR   = "s"
  TOBACCO = "t"
  COFFEE  = "c"

  SETTLER    = "Settler"
  MAYOR      = "Mayor"
  BUILDER    = "Builder"
  CRAFTSMAN  = "Craftsman"
  TRADER     = "Trader"
  CAPTAIN    = "Captain"
  PROSPECTOR = "Prospector"

  def initialize(setup)
    @setup = setup
    @trading_house = []
    @goods = [[CORN, 10], [INDIGO, 11], [SUGAR, 11], [TOBACCO, 9] , [COFFEE, 9]]
    @vps = {3 => 75, 4 => 100, 5 => 122}[players.size]
    # [capacity, taken, good (nil if none)]
    @cargo_ships = (1..3).map { |e| [e + players.size, 0, nil] }.extend(CargoShipList)
    @colonists = {3 => 55, 4 => 75, 5 => 95}[players.size]
    @buildings = Puerto::Building.available_buildings.dup
    @roles = [SETTLER, MAYOR, BUILDER, CRAFTSMAN, TRADER, CAPTAIN, PROSPECTOR]
    @finishing = false
  end

  def players
    @setup.players
  end

  def choose_role(role)
    i = @roles.index(role)
    @roles[i] = nil
  end

  def phase_finished?
    players.current.acted_as_governor and players.current.next_player == players.governor
  end

  def last_phase?
    players.current.next_player.governor?
  end

  def last_round?
    @finishing
  end

  def award_vps(player, amount)
    unless amount <= 0 or @vps < amount
      @vps -= amount
      player.add_vps(amount)
    end
  end

  def round_finished?
    @roles.count { |r| r.nil? } == players.size
  end

  def reset_roles
    @roles = [SETTLER, MAYOR, BUILDER, CRAFTSMAN, TRADER, CAPTAIN, PROSPECTOR]
  end

  def end_conditions_met?
    if @vps == 0
      return true
    end
    return false
  end

  def next
    players.next!
    @finishing = true unless !end_conditions_met?
    if phase_finished?
      reset_roles if round_finished?
      return true
    end
    return false
  end
end

module CargoShipList
  def to_s
    ret = []
    each do |capacity, taken, good|
      if good
        ret << "%d/%d(%s)" % [taken, capacity, good]
      else
        ret << "%d/%d" % [taken, capacity]
      end
    end
    ret.join(", ")
  end
end
