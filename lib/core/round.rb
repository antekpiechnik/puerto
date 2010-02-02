class Puerto::Core::Round
  attr_reader :game, :role

  def initialize(game, role)
    @game, @role = game, role
    @moves = @game.players.size
    @player = @game.players.current
    @game.roles.choose(@role)
  end

  def finished?
    @moves == 0
  end

  def next
    case role
    when Puerto::Core::Game::PROSPECTOR
      handle_prospector
    else
    end
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

  def handle_prospector
    if @player == game.players.current
      @game.award_doubloons(@player, 1)
    end
  end
end
