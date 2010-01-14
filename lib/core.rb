module Puerto::Core
end

['game', 'setup'].each do |mod|
  require File.join('lib', 'core', mod)
end
