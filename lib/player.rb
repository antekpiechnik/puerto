class Puerto::Player
  attr_reader :name, :buildings, :vp, :plantations, :doubloons, :goods

  def initialize(name)
    @name = name
    @buildings = []
    @plantations = []
    @vp = 0
    @doubloons = 0
    @goods = []
  end

  def self.validates_name_uniq?(names, new_name)
    new_name != "" and !names.include?(new_name)
  end

  def self.validates_player_no?(number)
    (3..5).include?(number)
  end

  def self.create(names)
    if self.validates_player_no?(names.length)
      return names.map { |name| self.new(name) }
    else
      return []
    end
  end

  def to_s
    @name
  end
end
