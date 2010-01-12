class Puerto::Handlers::Puerto < Puerto::Handlers::BaseHandler
  def initialize
    self.assign_handler(self)
  end

  def handler
    @handler
  end

  ##
  # Overriden because this is the main handler.
  def assign_handler(new_handler)
    @handler = new_handler
    @first_run = true
    new_handler.main = self.main
  end

  ##
  # Overriden because this is the main handler.
  def main
    self
  end

  def run
    frame("Welcome to PuertoRico. Implementation: Michal Bugno and Antek Piechnik")
  end

  def menu_options
    [
      ["1", ["Start", :start]],
      ["2", ["Top scores", :top]],
      ["3", ["Load game", :load]],
      ["0", ["Exit", :exit]],
    ]
  end

  ##
  # This is main loop, execution starts from here. It reads input and manages
  # output, also invokes {Puerto::Handlers::BaseHandler#handle} based on input
  # params.
  def main_loop
    @main_loop = true

    begin
      if @first_run
        @_out = @handler.run
        @first_run = false
      end
      redraw_template
      input = read_input
      unless input.nil?
        @_out = frame(@handler.handle(input).to_s, @handler.title)
      end
    end while @main_loop
  end

  ##
  # Handler method for starting game.
  def start(*args)
    self.assign_handler(Puerto::Handlers::Setup.new)
  end

  ##
  # Ends the main loop.
  def exit(*args)
    @main_loop = false
  end

  def title
    "Puerto Rico"
  end

  def menu(label)
    frame(@handler.menu_options.map { |n, s| "%d. %s" % [n, s[0]] }.join("   |   "), label)
  end

  def redraw_template
    clear
    puts flash if flash?
    puts menu(title)
    puts @_out if @_out
  end

end
