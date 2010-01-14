class Puerto::Handlers::Game < Puerto::Handlers::BaseHandler
  def initialize(setup)
    @setup = setup
    @game = Puerto::Core::Game.new(setup)
  end

  ##
  # @action
  def run
    frame(@game.players.join("\n"))
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
    self.assign_handler(Puerto::Handlers::PlayerState.new(@setup.players))
  end

  ##
  # @action
  def game_stats
    out = []
    out << ["Governor", players.governor.to_s]
    out << ["Trading house", @trading_house.to_s]
    out << ["VPs", @vps]
    out << ["Colonists", @colonists]
    out << ["Available buildings", @buildings.map { |n, a| "%s = %d" % [n, a] }.join(", ")]
    out << ["Goods", @goods.map { |g, a| "%s:%d" % [g, a] }.join(", ")]
    out << ["Cargo ships", @cargo_ships.to_s]
    tabular_output(out)
  end

  ##
  # @action
  def end_game
    self.assign_handler(:previous)
  end

  def title
    "Puerto Rico %d-player game -- %s moving" % [@game.players.size, @game.players.current.name]
  end
end
