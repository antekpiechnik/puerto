module Puerto::Handlers
end

["base_handler", "puerto", "game", "setup", "player_state", "phase"].each do |handler|
  require File.join('lib', 'handlers', handler)
end
