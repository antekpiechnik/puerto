class Puerto::Handlers::PlayerState < Puerto::Handlers::BaseHandler
  def initialize(players)
    @players = players
  end

  ##
  # @action
  def run
    if @picked_player.nil?
      frame("Pick a player.", "Player state")
    else
      frame("Player name: #{@picked_player.name}", @picked_player.name)
    end
  end

  def menu_options
    options = []
    @players.each_with_index do |player, number|
      options << [(number + 1).to_s, [player.to_s, :player_state, player]]
    end
    options << ["0", ["Back", :back_to_game]]
    return options
  end

  ##
  # @action
  # @param [Puerto::Player] picked player chosen with menu
  def player_state(picked)
    result = []
    result << ["Name", picked]
    result << ["Buildings", picked.buildings_pretty_print]
    result << ["Plantations", picked.plantations]
    result << ["Doubloons", picked.doubloons]
    result << ["Colonists", picked.colonists]
    result << ["Goods", picked.goods]
    if picked.current?
      result << ["VPs", picked.vps]
    end
    tabular_output(result)
  end

  ##
  # @action
  def back_to_game
    self.assign_handler(:previous)
  end

  def title
    if @picked_player.nil?
      return "Puerto Rico - pick a player for stars"
    else
      return "Puerto Rico %s - stats" % [@picked_player.name]
    end
  end
end
