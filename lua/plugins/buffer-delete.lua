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

elseif user.settings.buffer_deleter == 'snacks' then
    local snacks_bufdelete = require 'plugins.config.snacks'.snacks().bufdelete
    m.delete = function(id)
        snacks_bufdelete.delete({ buf = id, force = false })
    end
else
    m.delete = function()
        vim.cmd 'bd!'
    end
end

return m
