class Puerto::Player
  attr_reader :name, :buildings, :vp, :plantations, :doubloons, :goods
  attr_accessor :next_player
  attr_accessor :previous_player

  def initialize(name)
    @name = name
    @buildings = []
    @plantations = []
    @vp = 0
    @doubloons = 0
    @goods = []
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
      players.extend(Puerto::PlayerList)
      players.first.send(:governor!)
      players
    else
      []
    end
  end

  def to_s
    @name
  end

  private
  def governor!
    @current = @governor = true
  end

  def cancel_governor!
    @governor = false
  end

  def current!
    @current = true
  end

  public
  def current?
    @current
  end

  def governor?
    @governor
  end

  def next!
    @current = false
    if next_player.governor?
      next_player.send(:cancel_governor!)
      next_player.next_player.send(:governor!)
    else
      next_player.send(:current!)
    end
  end

  def self.loop_players(players)
    (players.length - 1).times do |i|
      players[i].next_player = players[i + 1]
      players[i + 1].previous_player = players[i]
    end
    players.last.next_player = players.first
    players.first.previous_player = players.last
  end
end

module Puerto::PlayerList
  def next!
    current.next!
  end

  def current
    find { |p| p.current? }
  end

  def governor
    find { |p| p.governor? }
  end
end
