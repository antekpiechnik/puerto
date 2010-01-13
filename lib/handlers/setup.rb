class Puerto::Handlers::Setup < Puerto::Handlers::BaseHandler
  attr_reader :main, :players

  def initialize
    @players = []
  end

  ##
  # @action
  def run
    if @players.empty?
      frame("Please set players")
    else
      player_text(@players)
    end
  end

  def menu_options
    [
      ["1", ["Set players", :set_players]],
      ["2", ["Start game", :start_game]],
      ["0", ["Back to main", :back_to_main]],
    ]
  end

  ##
  # @action
  def back_to_main
    self.assign_handler(main)
  end

  ##
  # @action
  def start_game
    if @players.empty?
      self.flash = "Please set players"
    else
      self.assign_handler(Puerto::Handlers::Game.new(self))
    end
  end

  ##
  # @action
  def set_players(*args)
    names = []
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
      if Puerto::Player::validates_name_uniq?(names, name)
        names << name
        to_go += 1
      end
    end
    @players = Puerto::Player.create(names)
    player_text(@players)
  end

  def title
    "Setup"
  end

  private
  def player_text(players)
    out = []
    players.each_with_index do |player, i|
      out << "Player %d: %s" % [i + 1, player]
    end
    out.join("\n")
  end
end
