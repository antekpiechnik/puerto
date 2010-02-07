##
# Base class representing player. Responsible for {create creating players},
# and keeping player state like Victory Points, plantations, # goods etc.
#
# Please note that the `players` Array returned by {create} is extended by
# {Puerto::PlayerList} providing useful methods.
class Puerto::Player
  attr_reader :name, :buildings, :vps, :plantations, :doubloons, :goods, :quarry_count
  attr_accessor :next_player, :previous_player

  def initialize(name)
    @name = name
    @buildings = []
    @plantations = []
    @vps = 0
    @doubloons = 0
    @quarry_count = 2
    @goods = []
    @colonists = 0
    @current = @governor = false
  end

  ##
  # A method for validating the uniqueness of a player being created
  #
  # @return [Boolean]
  def self.validates_name_uniq?(names, new_name)
    new_name != "" and !names.include?(new_name)
  end

  ##
  #
  # A method for validating the number of players
  #
  # @return [Boolean]
  def self.validates_player_no?(number)
    (3..5).include?(number)
  end

  ##
  # This method is the only way to create a valid player list. It sets current
  # the player, governor, links next/previous players and extends the list by useful
  # methods like returning current player.
  #
  # @return [Array extended by Puerto::PlayerList]
  def self.create(names)
    if self.validates_player_no?(names.length)
      players = names.map { |name| self.new(name) }
      players.extend(Puerto::PlayerList)
    else
      players = []
    end
    players
  end

  ##
  # String representation of player.
  #
  # @return [String]
  def to_s
    opts = []
    opts << "c" if current?
    opts << "g" if governor?
    if opts.empty?
      self.name
    else
      "%s (%s)" % [self.name, opts.join(",")]
    end
  end

  private
  def governor!
    @governor = true
  end

  def cancel_governor!
    @governor = false
  end

  def current!
    @current = true
  end

  def cancel_current!
    @current = false
  end

  public
  def add_doubloons(amount)
    @doubloons += amount unless amount <= 0
  end

  def add_vps(amount)
    @vps += amount unless amount <= 0
  end

  def add_colonists(amount)
    @colonists += amount unless amount <= 0
  end

  def free_city_space
    12 - @buildings.length
  end

  def award_building(name)
    if free_city_space > 0
      @buildings << [name, 0]
    else
      raise ArgumentError.new("No more space in the city") if player.buildings.include?(name)
    end
  end

  def current?
    @current
  end

  def governor?
    @governor
  end
end

##
# This module extends player list returned by {Puerto::Player.create}. It
# provides interface for {Puerto::PlayerList#next! switching to next player},
# getting {Puerto::PlayerList#current current player} and
# {Puerto::PlayerList#governor current governor}.
#
# @example
#   players = Puerto::Player.create(["a", "b", "c"])
#   players.current.name #=> "a"
#   players.next!
#   players.current.name #=> "b"
#   players.governor.name #=> "a"
module Puerto::PlayerList
  def self.extended(players)
    self.loop_players(players)
    players.first.send(:governor!)
    players.first.send(:current!)
  end

  ##
  # Switches to next player. Handles changing governor also (if needed)
  #
  # @return [void]
  def next!
    now = current
    @governor_count ||= 1
    if @governor_count % (count ** 2) == 0
      gov = governor
      gov.next_player.send(:current!)
      gov.next_player.send(:governor!)
      gov.send(:cancel_governor!)
      @governor_count = 0
    elsif @governor_count % count == 0
      now.next_player.next_player.send(:current!)
    else
      now.next_player.send(:current!)
    end
    now.send(:cancel_current!)
    @governor_count += 1
  end

  ##
  # Returns current player.
  #
  # @return [Puerto::Player] current player
  def current
    find { |p| p.current? }
  end

  ##
  # Returns current governor.
  #
  # @return [Puerto::Player] governor player
  def governor
    find { |p| p.governor? }
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
