local m = {}
local user  = require 'user'

if user.settings.status_line == 'airline' then
    return require 'plugins.config.airline'
else
    m.next_tab = function() end
    m.prev_tab = function() end
end

return m
