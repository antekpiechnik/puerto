require 'test/test_helper'

class OutputHelperTest < Test::Unit::TestCase
  def setup
    @object = Class.new
    @object.extend(Puerto::OutputHelper)
  end

  def test_tabular_output_returns_empty_string_for_empty_array
    assert_equal "", @object.send(:tabular_output, [])
  end
end
