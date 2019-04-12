local M = {}

local data = require "modules.data"
local sizes = require "modules.game.view.sizes"
local msgs = require "modules.msgs"

function M.init(self)
	local max_count = data.cfg.max_field_width * data.cfg.max_field_height
	self.tiles = {}
	local id
	for i = 1, max_count do
		id = factory.create(msgs.PATH_TILES_FACTORY)
		msg.post(id, msgs.DISABLE)
		self.tiles[i] = {
			id = id
		}
	end
end

function M.create(self, level_data)
	for y = 1, level_data.height do
		for x = 1, level_data.width do
		end
	end
end

return M