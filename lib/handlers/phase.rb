class Puerto::Handlers::Phase < Puerto::Handlers::BaseHandler
  def initialize(game, role)
    @game, @role = game, role
    @game.choose_role(role)
  end

  def menu_options
    [
      ["1", ["Next player", :next]],
    ]
  end

  ##
  # @action
  def next
    @game.players.next!
    if @game.phase_finished?
      if @game.round_finished?
        @game.reset_roles
      end
      self.assign_handler(:previous)
    else
      "Current player: %s" % [@game.players.current.to_s]
    end
  end

  ##
  # @action
  def run
    frame("Phase %s - players %s" % [@role, @game.players.current.to_s])
  end

  def title
    "Phase %s - players %s" % [@role, @game.players.current.to_s]
  end
end
