module Puerto::Handlers
end

["base_handler", "puerto", "game", "setup", "player_state", "round"].each do |handler|
  require File.join('lib', 'handlers', handler)
end
