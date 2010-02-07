class Puerto::Core::Round
  attr_reader :game, :role

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
    @moves -= 1
    game.players.next!
    finish if finished?
  end

  def first?
    @player == game.players.current
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
