local m = {}
local user = require 'user'

if user.settings.zoom == 'zoomwintab' then
    return require 'plugins.config.zoomwintab'
elseif user.settings.zoom == 'neo-zoom' then
    return require 'plugins.config.neo-zoom'
elseif user.settings.zoom == 'snacks' then
    local snacks = require 'plugins.config.snacks'.snacks()
    m.toggle_zoom = function()
        snacks.zen.zoom()
    end
else
    m.toggle_zoom = function() end
end

return m
