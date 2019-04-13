local M = {}

local data = require "modules.data"
local sizes = require "modules.game.view.sizes"
local msgs = require "modules.msgs"

local TILE_LABEL = "label"
local TILE_BACKGROUND = "sprite"

function M.init(self)
	local max_count = data.cfg.max_field_width * data.cfg.max_field_height
	self.tiles = {}
	local id
	for i = 1, max_count do
		id = factory.create(msgs.PATH_TILES_FACTORY)
		msg.post(id, msgs.DISABLE)
		self.tiles[i] = {
			id = id,
			url = msg.url(id)
		}
	end
end

function M.create(self, level_data)
	local index = 0
	local tile, tile_data
	for y = 1, #level_data do
		for x = 1, #level_data[y] do
			index = index + 1
			tile_data = level_data[x][y]
			tile = self.tiles[index]
			msg.post(tile.id, msgs.ENABLE)
			tile.x = x
			tile.y = y
			tile.url_label = msg.url(tile.url)
			tile.url_label.fragment = TILE_LABEL
			tile.url_back = msg.url(tile.url)
			tile.url_back.fragment = TILE_BACKGROUND
			label.set_text(tile.url_label, tile_data.letter)
			tile.letter = tile_data.letter
			tile.pos = sizes.get_position(x, y, sizes.Z_LAYERS.tiles)
			go.set_position(tile.pos, tile.id)
		end
	end
end

return M