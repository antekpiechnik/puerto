class Puerto::Handlers::Puerto < Puerto::Handlers::BaseHandler
  def self.main
    @@main
  end

  def initialize
    @previous_handler = []
    self.assign_handler(self)
    @@main = self
  end

  def handler
    @handler
  end

  ##
  # Overriden because this is the main handler.
  def assign_handler(new_handler, previous_handler = nil)
    if new_handler == :previous
      @handler = @previous_handler.pop
    else
      @handler = new_handler
      @previous_handler.push(previous_handler)
    end
    @first_run = true
    nil
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
        out = @handler.handle(input)
        @_out = frame(out.to_s, @handler.title) if out
      end
    end while @main_loop
  end

  ##
  # Handler method for starting game.
  #
  # @action
  def start
    self.assign_handler(Puerto::Handlers::Setup.new, self)
  end

  ##
  # Ends the main loop.
  #
  # @action
  def exit
    @main_loop = false
  end

  def title
    "Puerto Rico"
  end

  def menu(label)
    frame(@handler.menu_options.map { |n, s| "%s. %s" % [n.to_s, s[0]] }.join("   |   "), label)
  end

  def redraw_template
    self.clear
    puts self.flash if self.flash?
    puts self.menu(title)
    puts @_out if @_out
  end

  def flash=(msg)
    @flash = msg
  end

  def flash?
    ! @flash.nil?
  end

  def reset_flash
    f = @flash
    @flash = nil
    f
  end

  def flash
    frame(self.reset_flash, "Info")
  end
end
