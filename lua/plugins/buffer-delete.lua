local m = {}
local user = require 'user'

if user.settings.buffer_deleter == 'bufdelete' then
    local bufdelete = require 'bufdelete'.bufdelete
    m.delete = function(id)
        bufdelete(id or 0, true)
    end
elseif user.settings.buffer_deleter == 'mini' then
    local mini_bufremove = require 'mini.bufremove'
    m.delete = function(id)
        mini_bufremove.delete(id or 0, false)
    end
else
    m.delete = function()
        vim.cmd 'bd!'
    end
end

return m
