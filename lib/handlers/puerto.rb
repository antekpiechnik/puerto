class Puerto::Handlers::Puerto < Puerto::Handlers::BaseHandler
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
    frame("Welcome to PuertoRico. Implementation: Michal Bugno and Antek Piechnik", "Game")
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
      if @first_run
        @_out = handler.run
        @first_run = false
      end
      redraw_template
      input = read_input
      unless input.nil?
        @_out = frame(self.handler.handle(input).to_s, "Game")
      end
    end while @main_loop
  end

  def start(*args)
    self.handler = Puerto::Handlers::Setup.new(self)
  end

  def exit(*args)
    @main_loop = false
  end

  def title
    "Main menu"
  end
end
