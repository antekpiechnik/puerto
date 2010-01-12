class Puerto::Handlers::PlayerState < Puerto::Handlers::BaseHandler
  attr_reader :main, :game

  def initialize(game)
    @game = game
  end

  def run
    if @picked_player.nil?
      frame("Pick a player.", "Player state")
    else
      frame("Player name: #{@picked_player.name}", @picked_player.name)
    end
  end

  def menu_options
    options = []
    game.players.each_with_index do |player, number|
      options << [(number+1).to_s, [player.name.capitalize, :player_state, player]]
    end
    options << ["0", ["Back", :back_to_game]]
    return options
  end

  def player_state(*args)
    picked = args[0]
    result = "Name: %s\n" % picked.name
    result << "Buildings: %s\n" % picked.buildings.to_s
    result << "Plantations: %s\n" % picked.plantations.to_s
    result << "Doubloons: %d\n" % picked.doubloons
    result << "Goods: %s\n" % picked.goods.to_s
    if picked.current?
      result << "VPs: %d\n" % picked.vps
    end
    result
  end

  def back_to_game(*args)
    self.assign_handler(game)
  end

  def title
    if @picked_player.nil?
      return "Puerto Rico - pick a player for stars"
    else
      return "Puerto Rico %s - stats" % [@picked_player.name]
    end
  end
end
