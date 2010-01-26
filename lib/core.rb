module Puerto::Core
end

['game', 'setup', 'round'].each do |mod|
  require File.join('lib', 'core', mod)
end
