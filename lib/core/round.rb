class Puerto::Core::Round
  attr_reader :game, :role

  def initialize(game, role)
    @game, @role = game, role
    @moves = @game.players.size
    @game.choose_role(@role)
  end

  def finished?
    @moves == 0
  end

  def next
    @moves -= 1
    game.players.next!
    finish if finished?
  end

  private
  def finish
    game.roles.reset! if last_in_phase?
  end

  def last_in_phase?
    @game.roles.taken_count == @game.players.size
  end
end
