class Puerto::Core::Round
  def initialize(game, role)
  end

  def finished?
    players.round_finished?
  end
end
