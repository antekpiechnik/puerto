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
    @finishing = false
    @roles = RoleList.create(players.size)
  end

  def players
    @setup.players
  end

  def choose_role(role)
    @roles.choose(role)
  end

  ##
  # Boolean indicating that this is the last phase of game (ending conditions
  # are met).
  #
  # @return [Boolean] true if game finishes at the end of current phase
  def last_phase?
    @finishing
  end

  ##
  # Gives `amount` VPs to `player`. The game can finish with negative VPs, it's
  # only a matter of them being `<= 0` (during captain phase players take VPs
  # even if they physically finished).
  #
  # @param [Puerto::Player] player awarded
  # @param [Fixnum] amount amount of VPs (only positive)
  # @return [nil]
  def award_vps(player, amount)
    unless amount <= 0
      @vps -= amount
      @finishing ||= @vps <= 0
      player.add_vps(amount)
    end
  end

  def phase_finished?
    players.phase_finished?
  end

  def round_finished?
    @roles.taken_count == players.size
  end

  def winner
    sorted = players.sort do |a, b|
      result = b.vps <=> a.vps
      if result == 0
        result = b.doubloons <=> a.doubloons
      end
      result
    end
    sorted.first
  end

  def next
    players.next!
    if phase_finished?
      roles.reset! if round_finished?
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

module RoleList
  def self.create(players_no)
    k = Puerto::Core::Game
    roles = [k::SETTLER, k::MAYOR, k::BUILDER, k::CRAFTSMAN, k::TRADER, k::CAPTAIN]
    roles << k::PROSPECTOR if players_no >= 4
    roles << k::PROSPECTOR if players_no >= 5
    roles.map! { |e| [e, true, 0] }
    roles.extend(RoleList)
  end

  def each_valid
    each_with_index do |e, i|
      next if e[1] == false
      role = e[0].dup
      if e[2] > 0
        role = "%s (%dd)" % [e[0], e[2]]
      else
        role = e[0]
      end
      yield role, e[0], i
    end
  end

  def taken_count
    count { |e| e[1] }
  end

  def reset!
    each do |role|
      role[2] += 1 if role[1]
      role[1] = true
    end
  end

  def choose(role)
    i = self.index(self.find { |e| e[0] == role })
    raise ArgumentError.new("Role %p cannot be chosen" % [role]) unless i
    raise ArgumentError.new("Role %p already chosen" % [role]) if self[i][1] == false
    self[i][1] = false
  end
end
