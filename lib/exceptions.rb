##
# Base PuertoRico exception.
class Puerto::Error < Exception
end

##
# Raised when method should be implemented by user but it's not.
class Puerto::AbstractMethodError < Puerto::Error
end

##
# Raised when appropriate handler name couldn't be found.
class Puerto::HandlerNotFound < Puerto::Error
  attr_reader :klass, :name

  def initialize(klass, name)
    @klass, @name = klass, name
  end

  def message
    "Handler %p not found in %p" % [name, klass]
  end
end
