##
# Base class representing player. Responsible for {create creating players},
# and keeping player state like Victory Points, plantations, # goods etc.
#
# Please note that the `players` Array returned by {create} is extended by
# {Puerto::PlayerList} providing useful methods.
class Puerto::Player
  attr_reader :name, :buildings, :vps, :plantations, :doubloons, :goods
  attr_accessor :next_player, :previous_player

  def initialize(name)
    @name = name
    @buildings = []
    @plantations = []
    @vps = 0
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

  ##
  # This method is the only way to create valid player list. It sets current
  # player, governor, links next/previous players and extends the list by useful
  # methods like returning current player.
  #
  # @return [Array extended by Puerto::PlayerList]
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

  def add_doubloons(amount)
    @doubloons += amount
  end

  def add_vps(amount)
    @vps += amount
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
  ##
  # Switches to next player. Handles changing governor also (if needed)
  #
  # @return [void]
  def next!
    current.next!
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
end
