##
# Base PuertoRico exception.
#
# @see AbstractMethodError
# @see HandlerNotFound
class PuertoError < Exception
end

##
# Raised when method should be implemented by user but it's not.
class AbstractMethodError < PuertoError
end

##
# Raised when appropriate handler name couldn't be found.
class HandlerNotFound < PuertoError
  attr_reader :klass, :name

  def initialize(klass, name)
    @klass, @name = klass, name
  end

  def message
    "Handler %p not found in %p" % [name, klass]
  end
end
