require 'test/test_helper'

class SetupTest < Test::Unit::TestCase
  def test_doesnt_start_unless_players_set
    p = Puerto::Handlers::Puerto.new
    s = Puerto::Handlers::Setup.new
    p.instance_variable_set(:@handler, s)
    s.instance_variable_set(:@main, p)
    s.handle(:start_game)
    assert_equal s, s.handler
  end
end
