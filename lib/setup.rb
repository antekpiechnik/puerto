require 'game.rb'

class Setup < PuertoHandler
  attr_reader :main, :players

  def initialize(main)
    @main = main
    @players = []
  end

  def run
    frame("Players: %p" % [@players], "Main")
  end

  def menu_options
    [
      ["1", ["Set players", :set_players]],
      ["2", ["Start game", :start_game]],
      ["0", ["Back to main", :back_to_main]],
    ]
  end

  def back_to_main
    main.handler = main
  end

  def start_game
    main.handler = Game.new(self)
  end

  def set_players
    @players = []
    puts "Please set number of players"
    player_no = gets.to_i
    unless (3..5).include?(player_no)
      self.flash = "Players between 3 and 5 (inclusive)"
      return
    end
    to_go = 1
    while to_go <= player_no
      print "Player %d name: " % [to_go]
      name = gets.chomp
      if name != "" and not @players.include?(name)
        @players << name
        to_go += 1
      end
    end
    self.flash = "Players set: %p" % [@players]
  end

  def title
    "Setup"
  end
end
