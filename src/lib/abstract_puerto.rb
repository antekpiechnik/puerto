require 'output_helper.rb'

class AbstractPuerto
  include OutputHelper

  attr_accessor :flash_message

  def main
    raise AbstractMethodError
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
