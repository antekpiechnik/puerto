class Puerto::Handlers::Phase < Puerto::Handlers::BaseHandler
  def initialize(game, role)
    @game, @role = game, role
  end

  def menu_options
    []
  end

  ##
  # @action
  def run
    frame("Phase")
  end

  def title
    "Phase"
  end
end
