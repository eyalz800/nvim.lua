local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent
local user = require 'user'

m.toggle_zoom = function()
    if user.settings.edge == 'edgy' then
        if v.b.edgy_disable then
            v.b.edgy_disable = false
        else
            v.b.edgy_disable = true
        end
    end
    cmd 'ZoomWinTabToggle'
end

return m
