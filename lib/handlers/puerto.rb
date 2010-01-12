class Puerto::Handlers::Puerto < Puerto::Handlers::BaseHandler
  def initialize
    self.assign_handler(self)
  end

  def handler
    @handler
  end

  def assign_handler(new_handler)
    @handler = new_handler
    @first_run = true
    new_handler.main = self.main
  end

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

  def start(*args)
    self.assign_handler(Puerto::Handlers::Setup.new)
  end

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
