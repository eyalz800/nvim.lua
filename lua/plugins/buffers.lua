local m = {}
local user  = require 'user'
local bufdelete = require 'bufdelete'.bufdelete

local buffer_line = user.settings.buffer_line or user.settings.line

if buffer_line == 'airline' then
    return require 'plugins.config.airline'
elseif buffer_line == 'bufferline' then
    return require 'plugins.config.bufferline'
else
    m.next_buffer = function() end
    m.prev_buffer = function() end
    m.delete_buffer = function(id)
        bufdelete(id or 0, true)
    end
end

return m
