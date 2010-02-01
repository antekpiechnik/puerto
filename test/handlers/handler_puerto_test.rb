require 'test/test_helper'

class HandlerPuertoTest < Test::Unit::TestCase
  def setup
    @puerto = Puerto::Handlers::Puerto.new
  end

  def test_menu_responds
    assert_menu(@puerto, "1", "Start")
    # assert_menu(@puerto, "2", "Top scores")
    # assert_menu(@puerto, "3", "Load game")
    assert_menu(@puerto, "0", "Exit")
  end

  def test_assigning_handler_returns_nil
    assert_nil @puerto.assign_handler(@puerto)
  end

  def test_run_returns_string
    assert_equal String, @puerto.run.class
  end

  def test_main_returns_self
    assert_equal @puerto, @puerto.main
  end

  def test_menu_includes_actual_menus
    menu = @puerto.menu("Wat")
    @puerto.menu_options.each do |_, m|
      name = m[0]
      assert menu.include?(name)
    end
  end

  def test_menu_includes_label
    label = "Unique 332"
    menu = @puerto.menu(label)
    assert menu.include?(label)
  end
end
