require 'output.rb'

class AbstractPuerto
  include Output

  attr_accessor :flash_message

  def main_loop
    raise AbstractMethodError
  end

  def main
    raise AbstractMethodError
  end

  def read_input
    input = gets
    if input.nil? or input.chomp.empty?
      self.flash = "Empty input"
      return nil
    else
      input.chomp!
    end
    input
  end

  def flash
    return nil unless this_flash = @main.flash_message
    s = frame(this_flash, "Info")
    @main.reset_flash
    s
  end

  def flash=(msg)
    @main.flash_message = msg
  end

  def flash?
    ! @main.flash_message.nil?
  end

  def redraw_template
    clear
    puts flash if flash?
    puts menu(@main.handler.title)
  end

  def run
    raise AbstractMethodError
  end

  def title
    raise AbstractMethodError
  end

  def reset_flash
    @main.flash_message = nil
  end

  def handle(name)
    redraw_template
    if name.is_a?(String)
      menu = menu_options.assoc(name)
      if menu
        name = menu[1][1]
      else
        self.flash = "Invalid option"
      end
    end
    if name.is_a?(Symbol) and self.respond_to?(name)
      self.send(name)
    elsif name.is_a?(String)
      # do nothing
    else
      raise HandlerNotFound.new("Handler %p not found in %p" % [name, self.class])
    end
  end

  def clear
    system("clear")
  end

  def menu_options
    raise AbstractMethodError
  end

  class PuertoError < Exception
  end

  class AbstractMethodError < PuertoError
  end

  class HandlerNotFound < PuertoError
  end
end
