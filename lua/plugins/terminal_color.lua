local m = {}
local v = require 'vim'
local user = require 'user'
local executable = require 'vim.executable'.executable

local settings = (user.settings.external_terminal_opts or {})

if settings.set_background then
    m.set_background_color = function(color)
        if v.env.KITTY_LISTEN_ON ~= '' and executable 'kitty' then
            v.fn.system('kitty @ set-colors -a background=' .. color)
        end
    end
else
    m.set_background_color = function() end
end

return m
