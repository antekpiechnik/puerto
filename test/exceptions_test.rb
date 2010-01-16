require 'test/test_helper'

class ExceptionsTest < Test::Unit::TestCase
  def setup
    @handler = Puerto::HandlerNotFound.new(Object, :method)
  end

  def test_handler_not_found_klass_reader
    assert_equal Object, @handler.klass
  end

  def test_handler_not_found_name_reader
    assert_equal :method, @handler.name
  end

  def test_exception_message
    assert_equal "Handler :method not found in Object", @handler.message
  end
end
