class Puerto::Player
  attr_reader :name

  def initialize(name)
    @name = name
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
end
