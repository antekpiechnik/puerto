class Puerto::Handlers::Setup < Puerto::Handlers::BaseHandler
  attr_reader :main, :players

  def initialize
    @players = []
  end

  def run
    frame("Players: %p" % [@players])
  end

  def menu_options
    [
      ["1", ["Set players", :set_players]],
      ["2", ["Start game", :start_game]],
      ["0", ["Back to main", :back_to_main]],
    ]
  end

  def back_to_main(*args)
    self.assign_handler(main)
  end

  def start_game(*args)
    self.assign_handler(Puerto::Handlers::Game.new(self))
  end

  def set_players(*args)
    @names = []
    puts "Please set number of players"
    player_no = gets.to_i
    unless Puerto::Player::validates_player_no?(player_no)
      self.flash = "Players between 3 and 5 (inclusive)"
      return
    end
    to_go = 1
    while to_go <= player_no
      print "Player %d name: " % [to_go]
      name = gets.chomp
      if Puerto::Player::validates_name_uniq?(@names, name)
        @names << name
        to_go += 1
      end
    end
    @players = Puerto::Player::create(@names)
    self.flash = "Players set: %p" % [@players]
  end

  def title
    "Setup"
  end
end
