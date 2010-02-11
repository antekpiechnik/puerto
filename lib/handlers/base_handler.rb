require File.join('lib', 'output_helper')
require File.join('lib', 'exceptions')

##
# This is abstract class for handlers. Handler is a special class responsible
# for some _module_ of game, say main menu or loading game. The core is
# {#handle} method which dispatches requests to handlers.
#
# Handler actions *must* return String to render (even if it's empty).
#
# For changing the handler and passing context to another class use
# {#assign_handler} which automatically sets the `main` reference.
#
# All handler methods must be of signature
#     def method_for_handling(*args)
# Thus it's possible to send args to handler from menu.
class Puerto::Handlers::BaseHandler
  include Puerto::OutputHelper
  ##
  # Invoked once after `self` was passed execution by another handler.
  # @return [String] frame's content
  # @action
  def run(*args)
    raise Puerto::AbstractMethodError
  end

  ##
  # Sets the title of main frame managed by this handler.
  #
  # @return [String] main frame title
  def title
    raise Puerto::AbstractMethodError
  end

  ##
  # Change current handler and pass execuction to it.
  #
  # @param [Puerto::Handlers::BaseHandler, Symbol] new_handler new or existing
  #   instance of handler or symbol :previous for going back.
  # @return [nil] returns nil so that we don't print handler
  def assign_handler(new_handler)
    Puerto::Handlers::Puerto.main.assign_handler(new_handler, self)
  end

  ##
  # Returns current handler.
  #
  # @return [Puerto::Handlers::BaseHandler] current handler
  def handler
    Puerto::Handlers::Puerto.main.handler
  end

  ##
  # Handle requests (user input or explicit code handle requests). If `name` is
  # a String then handle it as menu request, else it should be a symbol so send
  # a method named `name` to current handler.
  #
  # @param name[String, Symbol] menu choice or handler method name
  # @return [String] response from handler
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
      self.send(name, *args)
    elsif name.is_a?(String)
      ""
    else
      raise Puerto::HandlerNotFound.new(self.class, name)
    end
  rescue Puerto::HandlerNotFound
    self.flash = "Not implemented yet"
    nil
  end

  ##
  # Override to provide menu for handler. Array elements should look like:
  #     ["1", ["Start", :start_game, additional, args]]
  #
  # First element is stringified number which will indicate what input should
  # trigger the option, second element is an array: name of menu option, handler
  # method symbol and args passed to handler.
  #
  # @return [Array<String, Array<String, Symbol, ...>>]
  def menu_options
    raise Puerto::AbstractMethodError
  end

  ##
  # @action
  def previous
    self.assign_handler(:previous)
  end

  def inspect
    "<%s:0x%x>" % [self.class.name, self.object_id]
  end
end
