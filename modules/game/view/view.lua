local M = {}

local sizes = require "modules.game.view.sizes"
local tiles = require "modules.game.view.tiles"

local move_handler

function M.init(self, logic_move_handler)
	move_handler = logic_move_handler

	tiles.init(self)
end

function M.create_level(self, level_data)
	tiles.create(self, level_data)
end

function M.on_input(self, action_id, action)
	if self.input_locked then return end

	if action.pressed then
		
	elseif action.released then
	end
end

return M