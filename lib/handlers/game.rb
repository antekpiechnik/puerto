class Puerto::Handlers::Game < Puerto::Handlers::BaseHandler
  attr_reader :main, :vps, :cargo_ships, :colonists

  CORN = "k"
  INDIGO = "i"
  SUGAR = "s"
  TOBACCO = "t"
  COFFEE = "c"

  def initialize(setup)
    @setup = setup
    @trading_house = []
    @goods = [[CORN, 10], [INDIGO, 11], [SUGAR, 11], [TOBACCO, 9] , [COFFEE, 9]]
    @vps = {3 => 75, 4 => 100, 5 => 122}[players.size]
    # [capacity, taken, good (nil if none)]
    @cargo_ships = (1..3).map { |e| [e + players.size, 0, nil] }.extend(CargoShipList)
    @colonists = {3 => 55, 4 => 75, 5 => 95}[players.size]
  end

  def players
    @setup.players
  end

  def current_player
    players.current
  end

  ##
  # @action
  def run
    frame(players.join("\n"))
  end

  def menu_options
    [
      ["1", ["Show player stats", :player_stats]],
      ["2", ["Show game stats", :game_stats]],
      ["3", ["Help", :help]],
      ["0", ["End game", :end_game]],
    ]
  end

  ##
  # @action
  def player_stats
    self.assign_handler(Puerto::Handlers::PlayerState.new(self))
  end

  ##
  # @action
  def game_stats
    out = []
    out << ["Governor", players.governor.to_s]
    out << ["Trading house", @trading_house.to_s]
    out << ["VPs", @vps]
    out << ["Colonists", @colonists]
    out << ["Goods", @goods.map { |g, a| "%s:%d" % [g, a] }.join(", ")]
    out << ["Cargo ships", @cargo_ships.to_s]
    tabular_output(out)
  end

  ##
  # @action
  def end_game
    self.assign_handler(@setup)
  end

  def title
    "Puerto Rico %d-player game -- %s moving" % [players.size, players.current.name]
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
