require 'game.rb'
require 'player.rb'

class Setup < PuertoHandler
  attr_reader :main, :players

  def initialize(main)
    @main = main
    @players = []
  end

  def run
    puts "Players: %p" % [@players]
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
    @names = []
    puts "Please set number of players"
    player_no = gets.to_i
    unless Player::validates_player_no?(player_no)
      self.flash = "Players between 3 and 5 (inclusive)"
      return
    end
    to_go = 1
    while to_go <= player_no
      print "Player %d name: " % [to_go]
      name = gets.chomp
      if Player::validates_name_uniq?(@names, name)
        @names << name
        to_go += 1
      end
    end
    @players = Player::create(@names)
    self.flash = "Players set: %p" % [@players]
  end

  def title
    "Setup"
  end
end
