class Puerto::Handlers::Game < Puerto::Handlers::BaseHandler
  attr_reader :main

  def initialize(setup)
    @setup = setup
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
    tabular_output(out)
  end

  ##
  # @action
  def end_game
    self.assign_handler(@setup)
  end

  def title
    "Puerto Rico %d-player game" % [players.size]
  end
end
