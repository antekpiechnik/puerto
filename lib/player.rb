##
# Base class representing player. Responsible for {create creating players},
# and keeping player state like Victory Points, plantations, # goods etc.
#
# Please note that the `players` Array returned by {create} is extended by
# {Puerto::PlayerList} providing useful methods.
class Puerto::Player
  attr_reader :name, :buildings, :vps, :plantations, :doubloons, :goods, :quarry_count, :colonists
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
    players.each do |player|
      Puerto::Core::Game::GOODS.sort_by{rand}[0..2].each {|good| player.add_goods(good, 1)}
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

  def assign_colonist(building)
    idx = @buildings.map { |b| b[0] }.index(name)
    idx ? buildings[idx][1] = 1 : nil
  end

  def add_goods(type, amount)
    @goods << [type, amount]
  end

  def free_buildings_space
    sum = 0
    @buildings.each { |b| sum += 1 if b[1] == 0 }
    sum
  end

  def free_city_space
    12 - @buildings.length
  end

  def loadable_goods(goods_already_in, goods_filled)
    if goods_already_in.include?(nil)
      return @goods.map{ |a| a[0] unless goods_filled.include?(a[0]) }.delete_if {|x| x.nil? }
    else
      return @goods.map{ |a| a[0] unless goods_already_in.include?(a[0]) or goods_filled.include?(a[0]) }.delete_if { |x| x.nil? }
    end
  end

  def tradeable_goods(trading_house)
    if trading_house.size == 4
      return @goods.map{ |a| a[0] unless trading_house.include?(a[0]) }.delete_if {|x| x.nil?}
    else
      return @goods.map{ |a| a[0] }
    end
  end

  def remove_good(good)
    idx = @goods.map{|a| a[0]}.index(good)
    @goods[idx][1] -= 1
    if @goods[idx][1] == 0
      @goods.delete_at(idx)
    end
  end

  def award_building(name)
    if free_city_space > 0
      @buildings << [name, 0]
    else
      raise ArgumentError.new("No more space in the city") if player.buildings.include?(name)
    end
  end

  def buildings_pretty_print
    output = ""
    @buildings.each do |building|
      output << building[0]
      building[1] == 1 ? output << " (active)," : output << " (inactive),"
    end
    output
  end

  def goods_pretty_print
    output = ""
    @goods.each do |goods|
      output << "#{goods[0]} - #{goods[1]}, "
    end
    output
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
