class Puerto::Handlers::Round < Puerto::Handlers::BaseHandler
  attr_reader :round

  def initialize(game, role)
    @game = game
    @round = Puerto::Core::Round.new(game, role)
  end

  def menu_options
    menu = []
    menu << ["1", ["Build", :build]] if @round.role == Puerto::Core::Game::BUILDER
    menu << ["1", ["LoadShips", :load_ships]] if @round.role == Puerto::Core::Game::CAPTAIN
    menu << ["1", ["Trade", :trade]] if @round.role == Puerto::Core::Game::TRADER
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
    input = gets.to_i
    return "Not bought" if input == 0
    begin
      building_name = @round.buy_building(input)
      "Bought %s" % [building_name]
    rescue ArgumentError => e
      e.message
    end
  end

  ##
  # @action
  def load_ships
    loadable_goods = @game.players.current.loadable_goods(
      @game.cargo_ships.map {|a| a[2]},
      @game.cargo_ships.map {|a| a[2] if a[1] == a[0]}.delete_if {|x| x.nil?}
    )
    output = []
    opts = []
    loadable_goods.each_index do |index|
      opts << index
      output << "#{index.to_s} #{loadable_goods[index].to_s}"
    end
    puts output.join("\n")
    begin
      input = gets.to_i
    end while not opts.include?(input)
    if @game.load_good(loadable_goods[input])
      "Loaded"
      @game.players.current.remove_good(loadable_goods[input])
      @game.award_vps(@game.players.current, 1)
      if @game.vps == 0
        @game.finishing = true
      end
      @round.acted
      @game.next
    else
      "Fale"
    end
  end

  ##
  # @action
  def trade
    tradeable_goods = @game.players.current.tradeable_goods(@game.trading_house)
    output = []
    opts = []
    tradeable_goods.each_index do |index|
      opts << index
      output << "#{index.to_s} #{tradeable_goods[index].to_s}"
    end
    if opts.size > 0
      puts output.join("\n")
      begin
        input = gets.to_i
      end while not opts.include?(input)
      @game.trade_good(tradeable_goods[input])
      @game.players.current.remove_good(tradeable_goods[input])
      @game.award_doubloons(@game.players.current, 3)
      @round.acted
      @game.next
    else
      "Nothing to trade"
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
