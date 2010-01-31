class Puerto::Handlers::Round < Puerto::Handlers::BaseHandler
  attr_reader :round

  def initialize(game, role)
    @game = game
    @round = Puerto::Core::Round.new(game, role)
  end

  def menu_options
    menu = []
    menu << ["1", ["Next", :next]]
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
  def run
    frame("Oh, hai!")
  end

  def title
    "Role %s : player %s" % [@round.role, @round.game.players.current.to_s]
  end
end
