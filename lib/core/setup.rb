class Puerto::Core::Setup
  attr_accessor :players

  def initialize
    @players = []
  end

  def players?
    ! @players.empty?
  end
end
