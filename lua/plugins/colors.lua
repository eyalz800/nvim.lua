local m = {}
local v = require 'vim'
local user = require 'user'
local cmd = require 'vim.cmd'.silent
local file_readable = require 'vim.file_readable'.file_readable
local expand = v.fn.expand
local system = v.fn.system
local readfile = v.fn.readfile

local persistent_color_path = expand('~/.vim/.color')

m.set = function()
    local colorscheme = user.settings.colorscheme
    cmd('colorscheme ' .. colorscheme)
end

m.pre_switch_color = function() end

m.post_switch_color = function()
    local success, colorscheme = pcall(require, 'plugins.colors.' .. v.g.colors_name)
    if success and colorscheme ~= true and colorscheme.apply then
        if not colorscheme.apply() or not file_readable(persistent_color_path) then
            return
        end

        if readfile(persistent_color_path)[1] == v.g.colors_name then
            return
        end

        system('echo ' .. v.g.colors_name .. ' > ' .. persistent_color_path)
        if v.env.TMUX then
            system 'tmux source ~/.tmux.conf'
        end
    end
end

return m
