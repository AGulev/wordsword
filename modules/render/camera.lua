local M = {
    win_x = 0,
    win_y = 0,
    config_x = 0,
    config_y = 0,
    settings_x = 0,
    settings_y = 0,
    fit = {
        sx = 0,
        sy = 0,
        ox = 0,
        oy = 0
    },
    zoom = {
        sx = 0,
        sy = 0,
        ox = 0,
        oy = 0
    },
    stretch = {
        sx = 0,
        sy = 0,
        ox = 0,
        oy = 0
    },
}

function M.action_to_mode(action, adj)
    return vmath.vector3(action.screen_x / adj.sx - adj.ox, action.screen_y / adj.sy - adj.oy, 0)
end

function M.world_to_mode(pos, adj)
    return vmath.vector3((pos.x + adj.ox) * adj.sx, (pos.y + adj.oy) * adj.sy, 0)
end

function M.screen_to_gui_pos(pos, adj)
    pos.x = pos.x / adj.sx - adj.ox
    pos.y = pos.y / adj.sy - adj.oy
end

function M.screen_to_gui_size(pos, adj)
    pos.x = pos.x / adj.sx
    pos.y = pos.y / adj.sy
end

return M
