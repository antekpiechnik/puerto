class Puerto::Handlers::Round < Puerto::Handlers::BaseHandler
  def initialize(game, role)
    @game, @role = game, role
    @game.roles.choose(role)
    if role == Puerto::Core::Game::PROSPECTOR
      @moves = 1
    else
      @moves = @game.players.size
    end
  end

  def menu_options
    menu = []
    menu << ["1", ["Next", :next]]
    menu
  end

  ##
  # @action
  def next
    @game.next
    if @game.phase_finished?
      @game.roles.reset!
    end
    @moves -= 1
    if @moves == 0
      self.assign_handler(:previous)
    else
      "Role %s: \nCurrent player: %s" % [@role, @game.players.current.to_s]
    end
  end

  ##
  # @action
  def run
    frame("Oh, hai!")
  end

  def title
    "Role %s : player %s" % [@role, @game.players.current.to_s]
  end
end
