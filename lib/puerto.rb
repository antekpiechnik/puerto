module Puerto
end

require File.join('lib', 'handlers')
require File.join('lib', 'player')

if __FILE__ == $0
  puerto = Puerto::Handlers::Puerto.new
  puerto.main_loop
end
