local m = {}
local user  = require 'user'

local buffer_line = user.settings.buffer_line or user.settings.line

if buffer_line == 'airline' then
    return require 'plugins.config.airline'
elseif buffer_line == 'bufferline' then
    return require 'plugins.config.bufferline'
else
    m.next_buffer = function() end
    m.prev_buffer = function() end
    m.delete_buffer = require 'plugins.buffer-delete'.delete
    m.switch_to_buffer = function() return function() end end
    m.pick_buffer = function() end
end

return m
