local M = {}

-- pathes
M.PATH_OBJ = "."
M.PATH_COMP = "#"
M.PATH_RENDER = "@render:"
M.PATH_SYSTEM = "@system:"

M.PATH_TILES_FACTORY = "factories#tiles"

-- screens
M.SRC_GAME = hash("game_screen")

-- popups

-- custom events

-- defold events

-- objects
M.ENABLE = hash("enable")
M.DISABLE = hash("disable")

-- render_script
M.RENDER_WINDOW_RESIZED = hash("window_resized")
M.RENDER_CLEAR_COLOR = hash("clear_color")
M.RENDER_SET_VIEW_PROJECTION = hash("set_view_projection")

M.SRC_LANDSCAPE = hash("landscape")
M.SRC_PORTRAIT = hash("portrait")

--input
M.I_CLICK = hash("click")

local ADD_FOCUS = hash("acquire_input_focus")
local REMOVE_FOCUS = hash("release_input_focus")

function M.focus(self)
	if not self.input_inited then
		self.input_inited = true
		msg.post(M.PATH_OBJ, ADD_FOCUS)
	end
end

function M.remove(self)
	if self.input_inited then
		self.input_inited = nil
		msg.post(M.PATH_OBJ, REMOVE_FOCUS)
	end
end


return M