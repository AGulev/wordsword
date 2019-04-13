local M = {}
local msgs = require "modules.msgs"

M.Z_LAYERS = {
	background = -0.99,
	tiles = -0.5,
	--[3] = 0,
	--[4] = 0.5,
	--[5] = 0.9
}

local TOP_LEFT_CORNER = {
	[msgs.SRC_PORTRAIT] = vmath.vector3(150, 908, 0)
}

local ROTATIONS = {
	[msgs.SRC_PORTRAIT] = {
		[0] = 0,
		[90] = 90,
		[180] = 180,
		[270] = 270
	}
}

--game
M.CELL_SIZE = vmath.vector3(90, 90, 0)
local LINE_SIZE = 4 --px
local CLICK_ZONE = vmath.vector3(120, 120, 0) * 0.5

local orientation = msgs.SRC_PORTRAIT

function M.get_position(x, y, layer, vector)
	local pos
	if vector then
		pos = vector
		pos.x = TOP_LEFT_CORNER[orientation].x
		pos.y = TOP_LEFT_CORNER[orientation].y
	else
		pos = vmath.vector3(TOP_LEFT_CORNER[orientation])
	end
	pos.x = pos.x + (x - 1) * M.CELL_SIZE.x
	pos.y = pos.y - (y - 1) * M.CELL_SIZE.y
	pos.z = layer
	return pos
end

function M.get_line_rotation(from, to)
	local x = orientation == msgs.SRC_PORTRAIT and M.CELL_SIZE.x or M.CELL_SIZE.y
	local y = orientation == msgs.SRC_PORTRAIT and M.CELL_SIZE.y or M.CELL_SIZE.x
	if from.x < to.x then
		return ROTATIONS[orientation][270], (to.x - from.x) * x / LINE_SIZE
	elseif from.x > to.x then
		return ROTATIONS[orientation][90], (from.x - to.x) * x / LINE_SIZE
	elseif from.y < to.y then
		return ROTATIONS[orientation][180], (to.y - from.y) * y / LINE_SIZE
	elseif from.y > to.y then
		return ROTATIONS[orientation][0], (from.y - to.y) * y / LINE_SIZE
	end
end

function M.AABB(tile_pos, click_pos)
	if click_pos.x > tile_pos.x - CLICK_ZONE.x and
	click_pos.x < tile_pos.x + CLICK_ZONE.x and
	click_pos.y > tile_pos.y - CLICK_ZONE.y and
	click_pos.y < tile_pos.y + CLICK_ZONE.y then
		return true
	end
	return false
end

function M.set_orientation(orient)
	orientation = orient
end

return M
