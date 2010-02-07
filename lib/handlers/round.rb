class Puerto::Handlers::Round < Puerto::Handlers::BaseHandler
  attr_reader :round

  def initialize(game, role)
    @game = game
    @round = Puerto::Core::Round.new(game, role)
  end

  def menu_options
    menu = []
    menu << ["1", ["Build", :build]] if @round.role == Puerto::Core::Game::BUILDER
    menu << ["0", ["Next", :next]]
    menu
  end

  ##
  # @action
  def next
    round.next
    if round.finished?
      self.assign_handler(:previous)
    else
      "Role %s: \nCurrent player: %s" % [@role, @game.players.current.to_s]
    end
  end

  ##
  # @action
  def build
    puts @game.buildings.to_s(@game.players.current, @round.first?)
    compacted_buildings = @game.buildings.compacted_buildings
    opts = compacted_buildings.map { |e| e.first } + [0]
    begin
      input = gets.to_i
    end while not opts.include?(input)
    if @game.buildings.buy_building(@game.players.current, compacted_buildings[input - 1][1].name)
      "Bought"
      @round.acted
      @game.next
    else
      "Not bought"
    end
  end

  ##
  # @action
  def run
    frame("Current role: %s" % [@round.role])
  end

  def title
    "Role %s : player %s" % [@round.role, @round.game.players.current.to_s]
  end
end
