require 'test/test_helper'

class HandlerSetupTest < Test::Unit::TestCase
  def setup
    @setup = Puerto::Handlers::Setup.new
  end

  def test_menu_responds
    assert_menu(@setup, "1", "Set players")
    assert_menu(@setup, "2", "Start game")
    assert_menu(@setup, "0", "Back to main")
  end

  def test_run_displays_notice_if_no_players_set
    run = @setup.run
    assert run.include?("Please set players")
  end

  def test_run_displays_table_of_players_if_set
    core_setup = Puerto::Core::Setup.new
    core_setup.players = Puerto::Player.create(["Michal", "Genowefa", "Leokadia"])
    @setup.instance_variable_set(:@setup, core_setup)
    run = @setup.run
    assert run.include?("Michal")
    assert run.include?("Genowefa")
    assert run.include?("Leokadia")
  end

  def test_title
    assert_equal "Setup", @setup.title
  end
end
