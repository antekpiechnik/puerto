class Puerto::Handlers::Game < Puerto::Handlers::BaseHandler
  attr_reader :main

  def initialize(setup)
    @setup = setup
  end

  def players
    @setup.players
  end

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

  def player_stats(*args)
    self.assign_handler(Puerto::Handlers::PlayerState.new(self))
  end

  def end_game(*args)
    self.assign_handler(@setup)
  end

  def title
    "Puerto Rico %d-player game" % [players.size]
  end
end
