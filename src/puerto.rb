require 'abstract_puerto.rb'
require 'game.rb'

class Puerto < AbstractPuerto
  attr_reader :handler

  def handler=(handler)
    @handler = handler
    @first_run = true
  end

  def run
    puts "Welcome to PuertoRico. Implementation: Michal Bugno and Antek Piechnik"
  end

  def menu_options
    [
      ["1", ["Start", :start]],
      ["2", ["Top scores", :top]],
      ["3", ["Load game", :load]],
      ["0", ["Exit", :exit]],
    ]
  end

  def main_loop
    @main_loop = true
    @main = self
    self.handler = self
    begin
      redraw_template
      if @first_run
        handler.run
        @first_run = false
      end
      input = read_input
      self.handler.handle(input) unless input.nil?
    end while @main_loop
  end

  def start
    self.handler = Game.new(self)
  end

  def exit
    end_main_loop
    clear
    puts "Good bye"
  end

  def title
    "Main menu"
  end

  def end_main_loop
    @main_loop = false
  end
end

if __FILE__ == $0
  p = Puerto.new
  p.main_loop
end
