local m = {}
local user = require 'user'

if user.settings.zoom == 'zoomwintab' then
    return require 'plugins.config.zoomwintab'
elseif user.settings.zoom == 'neo-zoom' then
    return require 'plugins.config.neo-zoom'
else
    m.toggle_zoom = function() end
end

return m
