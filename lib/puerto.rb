require 'puerto_handler.rb'
require 'setup.rb'

class Puerto < PuertoHandler
  attr_reader :handler

  def initialize
    self.handler = self
    @main = self
  end

  def handler=(handler)
    @handler = handler
    @first_run = true
  end

  def run
    puts frame("Welcome to PuertoRico. Implementation: Michal Bugno and Antek Piechnik", "Welcome")
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
    self.handler = Setup.new(self)
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
