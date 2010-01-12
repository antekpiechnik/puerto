require 'test/test_helper'

class PlayerStateTest < Test::Unit::TestCase
  def test_current_sees_his_vp
    p = Puerto::Handlers::Puerto.new
    s = Puerto::Handlers::Setup.new
    p.instance_variable_set(:@handler, s)
    s.instance_variable_set(:@main, p)
    s.handle(:start_game)
    assert_equal s, s.handler
  end
end
