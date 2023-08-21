local m = {}
local user  = require 'user'
local cmd = require 'vim.cmd'.silent

local buffer_line = user.settings.buffer_line or user.settings.line

if buffer_line == 'airline' then
    return require 'plugins.config.airline'
elseif buffer_line == 'bufferline' then
    return require 'plugins.config.bufferline'
else
    m.next_buffer = function() end
    m.prev_buffer = function() end
    m.delete_buffer = function(id)
        if id then
            cmd('Bclose ' .. id)
        else
            cmd 'Bclose'
        end
    end
end

return m
