local m = {}
local cmd = require 'vim.cmd'.silent
local user = require 'user'

m.init = function()
    vim.g.zoomwintab_remap = 0
end

m.toggle_zoom = function()
    if user.settings.edge == 'edgy' then
        if vim.b.edgy_disable then
            vim.b.edgy_disable = false
        else
            vim.b.edgy_disable = true
        end
    end
    cmd 'ZoomWinTabToggle'
end

return m
