class Puerto::Core::Round
  attr_reader :game, :role, :moves

  def initialize(game, role)
    @game, @role = game, role
    @moves = @game.players.size
    @player = @game.players.current
    @game.roles.choose(@role)
    @action_taken = 0
  end

  def finished?
    if @moves == 0
      if acted?
        @action_taken = 0
        @moves = @game.players.size
        return false
      else
        return true
      end
    end
  end

  def acted?
    @action_taken == 1
  end

  def acted
    @action_taken = 1
  end

  def next
    case role
      when Puerto::Core::Game::PROSPECTOR then handle_prospector
      when Puerto::Core::Game::MAYOR then handle_mayor
      else
    end

    @moves -= 1
    game.players.next!
    finish if finished?
  end

  def first?
    @player == game.players.current
  end

  ##
  # mozna kupowac w tej chwili ile sie chce i gra nie konczy rundy, powinna byc
  # mozliwosc kupienia 1 budynku. poza tym trzeba wykekstrahowac finishowanie i
  # redukowanie @moves do jakiejs osobnej funkcji i wolac to w #next i tutaj
  # tez.
  #
  # jak widzisz obsluge szitu oparlem na wyjatkach, jesli jakis leci to w
  # handlerze go lapiemy i wypluwamy jego tresc (ktora jest wytlumaczeniem
  # dlaczego nie mozna kupic). reszta tych akcji tez powinna zostac zrobiona w
  # ten sposob chyba
  def buy_building(input)
    compacted_buildings = game.buildings.compacted_buildings
    opts = compacted_buildings.map { |e| e.first }
    name = compacted_buildings[input - 1][1].name
    if game.buildings.buy_building(game.players.current, name)
      self.acted
      game.next
      name
    else
      raise ArgumentError.new("Couldn't buy")
    end
  end

  private
  def finish
    if last_in_phase?
      game.roles.reset!
      game.reset_trading_house! if game.trading_house_full?
    end
  end

  def last_in_phase?
    game.roles.taken_count == game.players.size
  end

  def handle_prospector
    if @player == game.players.current
      game.award_doubloons(@player, 1)
      @moves = 1
    end
  end

  def handle_mayor
    game.distribute_colonists
    @moves = 1
  end
end
