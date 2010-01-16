class Puerto::Handlers::Phase < Puerto::Handlers::BaseHandler
  def initialize(game, role)
    @game, @role = game, role
    @game.choose_role(role)
  end

  def menu_options
    menu = []
    if @game.last_player_in_phase?
      menu << ["1", ["Finish phase", :next]]
    else
      menu << ["1", ["Next player", :next]]
    end
    menu
  end

  ##
  # @action
  def next
    finished = @game.next
    if finished
      self.assign_handler(:previous)
    else
      "Role %s: \nCurrent player: %s" % [@role, @game.players.current.to_s]
    end
  end

  ##
  # @action
  def run
    frame("Role %s - players %s" % [@role, @game.players.current.to_s])
  end

  def title
    "Role %s - players %s" % [@role, @game.players.current.to_s]
  end
end
