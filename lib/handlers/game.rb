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
    menu = []
    @game.roles.each_with_index do |role, i|
      next if role.nil?
      menu << [(i + 97).chr, [role, :set_role, role]]
    end
    menu << ["1", ["Show player stats", :player_stats]]
    menu << ["2", ["Show game stats", :game_stats]]
    menu << ["0", ["End game", :previous]]
    menu
  end

  ##
  # @action
  def player_stats
    self.assign_handler(Puerto::Handlers::PlayerState.new(@setup.players))
  end

  def set_role(role)
    self.assign_handler(Puerto::Handlers::Phase.new(@game, role))
  end

  ##
  # @action
  def game_stats
    out = []
    out << ["Governor", @game.players.governor.to_s]
    out << ["Trading house", @game.trading_house.to_s]
    out << ["VPs", @game.vps]
    out << ["Colonists", @colonists]
    out << ["Available buildings", @game.buildings.map { |n, a| "%s = %d" % [n, a] }.join(", ")]
    out << ["Goods", @game.goods.map { |g, a| "%s:%d" % [g, a] }.join(", ")]
    out << ["Cargo ships", @game.cargo_ships.to_s]
    tabular_output(out)
  end

  def title
    "Role %s" % [@game.players.size, @game.players.current.name]
  end
end
