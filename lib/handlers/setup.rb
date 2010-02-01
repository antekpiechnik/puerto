class Puerto::Handlers::Setup < Puerto::Handlers::BaseHandler
  def initialize
    @setup = Puerto::Core::Setup.new
  end

  ##
  # @action
  def run
    if ! @setup.players?
      frame("Please set players")
    else
      player_text(@setup.players)
    end
  end

  def menu_options
    [
      ["1", ["Set players", :set_players]],
      ["2", ["Start game", :start_game]],
      ["0", ["Back to main", :previous]],
    ]
  end

  ##
  # @action
  def start_game
    # default players set
    unless @setup.players?
      @setup.players = Puerto::Player.create(["Michal", "Tomasz", "Antek", "Jan"])
    end

    if @setup.players?
      self.assign_handler(Puerto::Handlers::Game.new(@setup))
    else
      self.flash = "Please set players"
    end
  end

  ##
  # @action
  def set_players
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
    @setup.players = Puerto::Player.create(names)
    player_text(@setup.players)
  end

  def title
    "Setup"
  end

  private
  def player_text(players)
    out = []
    players.each_with_index do |player, i|
      out << ["Player %d" % [i + 1], player]
    end
    tabular_output(out)
  end
end
