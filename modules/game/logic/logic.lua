local M = {}

local wordsword = require "wordsword.wordsword"
local events = require "modules.game.events"

local handlers = {}

handlers[events.INIT] = function(self, level_options)
	self.state = {}
	local tmp
	local state = self.state
	for x = 1, level_options.width do
		state[x] = {}
		for y = 1, level_options.height do
			tmp = {}
			state[x][y] = tmp
		end
	end
	return true
end

handlers[events.FILL] = function(self, tree)
	self.tree = tree
	local tmp
	local state = self.state
	for y = 1, #state do
		for x = 1, #state[y] do
			tmp = state[y][x]
			tmp.letter, tmp.h_letter = tree:get_letter()
		end
	end
	return true, state
end

function M.move_handler(self, game_event, event_data)
	if handlers[game_event] then
		return handlers[game_event](self, event_data)
	end
	return false
end

return M