require 'test/unit'
require 'lib/puerto'

module TestHelpers
  def assert_menu(handler, shortcut, name)
    option = handler.menu_options.assoc(shortcut)
    assert option, "No menu option for shortcut %p" % [shortcut]
    actual_name, method = option[1]
    assert handler.respond_to?(method), "Handler doesn't respond to %p" % [method]
    assert_equal name, actual_name
  end
end

class Test::Unit::TestCase
  include TestHelpers
end
