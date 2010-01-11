require File.join('lib', 'output_helper')
require File.join('lib', 'exceptions')

##
# This is abstract class for handlers. Handler is a special class responsible
# for some _module_ of game, say main menu or loading game. The core is
# {#handle} method which dispatches requests to handlers.
#
# Handler actions *must* return String to render (even if it's empty).
class Puerto::Handlers::BaseHandler
  include Puerto::OutputHelper

  attr_accessor :flash_message

  def main
    raise Puerto::AbstractMethodError
  end

  def run(*args)
    raise Puerto::AbstractMethodError
  end

  def title
    raise Puerto::AbstractMethodError
  end

  def handler=(new_handler)
    main.handler = new_handler
  end

  def handler
    main.handler
  end

  ##
  # Handle requests (user input or explicit code handle requests). If `name` is
  # a String then handle it as menu request, else it should be a symbol so send
  # a method named `name` to current handler.
  #
  # @param name[String, Symbol] menu choice or handler method name
  # @return String response from handler
  # @raise [HandlerNotFound] raised if handler method was not found in current
  #   handler
  def handle(name)
    if name.is_a?(String)
      menu = menu_options.assoc(name)
      if menu
        name, *args = menu[1][1 .. -1]
      else
        self.flash = "Invalid option"
      end
    end
    if name.is_a?(Symbol) and self.respond_to?(name)
      self.send(name, args)
    elsif name.is_a?(String)
      ""
    else
      raise Puerto::HandlerNotFound.new(self.class, name)
    end
  end

  ##
  # Override to provide menu for handler. Array elements should look like:
  #     ["1", ["Start", :start_game]]
  #
  # First element is stringified number which will indicate what input should
  # trigger the option, second element is an array: name of menu option and
  # handler method symbol.
  #
  # @return [Array<String, Array<String, Symbol>>]
  def menu_options
    raise Puerto::AbstractMethodError
  end
end
