class Puerto::Handlers::PlayerState < Puerto::Handlers::BaseHandler
  attr_reader :main, :game

  def initialize(main, game)
    @main = main
    @game = game
    @picked_player = nil
  end

  def run
    if @picked_player.nil?
      puts frame("Pick a player.", "Player state")
    else
      puts frame("Player name: #{@picked_player.name}", @picked_player.name)
    end
  end

  def menu_options
    options = []
    main.players.each do |player, number|
      options << [(number+1).to_s, [player.name.capitalize, :player_state, player]]
    end
    options << ["0", ["Back", :back_to_game]]
    return options
  end

  def player_state(*args)
    @picked_player = player
  end

  def back_to_game(*args)
    main.handler = game
  end

  def title
    if @picked_player.nil?
      return "Puerto Rico - pick a player for stars"
    else
      return "Puerto Rico %s - stats" % [@picked_player.name]
    end
  end
end 
