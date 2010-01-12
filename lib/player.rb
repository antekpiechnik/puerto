class Puerto::Player
  attr_reader :name
  attr_accessor :next_player

  def initialize(name)
    @name = name
    @current = @governor = false
  end

  def self.validates_name_uniq?(names, new_name)
    new_name != "" and !names.include?(new_name)
  end

  def self.validates_player_no?(number)
    (3..5).include?(number)
  end

  def self.create(names)
    if self.validates_player_no?(names.length)
      players = names.map { |name| self.new(name) }
      self.loop_players(players)
      players.first.governor!
      players
    else
      []
    end
  end

  def governor!
    @current = @governor = true
  end

  def governor?
    @governor
  end

  def current?
    @current
  end

  def self.loop_players(players)
    (players.length - 1).times do |i|
      players[i].next_player = players[i + 1]
    end
    players.last.next_player = players.first
  end
end
