class Puerto::Handlers::Game < Puerto::Handlers::BaseHandler
  attr_reader :main

  def initialize(main)
    @main = main
  end

  def players
    main.players
  end

  def run
    puts frame(players.join("\n"), "Players")
  end

  def menu_options
    [
      ["1", ["Show player stats", :player_stats]],
      ["2", ["Show game stats", :game_stats]],
      ["3", ["Help", :help]],
    ]
  end

  def title
    "Puerto Rico %d-player game" % [players.size]
  end
end
