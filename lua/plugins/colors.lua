local m = {}
local v = require 'vim'
local user = require 'user'
local cmd = require 'vim.cmd'.silent
local file_readable = require 'vim.file_readable'.file_readable
local terminal_color = require 'plugins.terminal_color'

local readfile = v.fn.readfile
local expand = v.fn.expand
local system = v.fn.system

local tmux_color_path = expand '~/.tmux.color'

m.set = function()
    local color_name = user.settings.colorscheme
    local success, colorscheme = pcall(require, 'plugins.colors.' .. color_name)
    if success and colorscheme.set_background then
        colorscheme.set_background(color_name)
    end
    cmd('colorscheme ' .. color_name)
end

m.pre_switch_color = function() end

m.post_switch_color = function()
    local success, colorscheme = pcall(require, 'plugins.colors.' .. v.g.colors_name)
    if success and colorscheme.apply then
        if not colorscheme.apply() then
            return
        end

        v.opt.guicursor = 'n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20'

        local bg = v.fn.synIDattr(v.fn.hlID 'Normal', 'bg')
        if bg ~= '' then
            terminal_color.set_background_color(bg)
        end

        local color_name = colorscheme.name or v.g.colors_name
        if file_readable(tmux_color_path) and readfile(tmux_color_path)[1] == color_name then
            return
        end

        system('echo -n ' .. color_name .. ' > ' .. tmux_color_path)
        if v.env.TMUX then
            system 'tmux source ~/.tmux.conf'
        end
    end
end

return m
