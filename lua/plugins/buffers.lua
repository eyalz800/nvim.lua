local m = {}
local user  = require 'user'

if user.settings.line == 'airline' then
    return require 'plugins.config.airline'
else
    m.next_buffer = function() end
    m.prev_buffer = function() end
end

return m
