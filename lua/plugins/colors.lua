local m = {}
local user = require 'user'
local cmd = require 'vim.cmd'.silent
local file_readable = require 'vim.file_readable'.file_readable
local terminal_color = require 'plugins.terminal_color'

local readfile = vim.fn.readfile
local expand = vim.fn.expand
local system = vim.fn.system

local tmux_color_path = expand '~/.tmux.color'

m.subscribers = {}

m.subscribe = function(subscriber)
    table.insert(m.subscribers, subscriber)
end

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
    local success, colorscheme = pcall(require, 'plugins.colors.' .. vim.g.colors_name)
    if success and colorscheme.apply then
        if not colorscheme.apply() then
            return
        end

        vim.opt.guicursor = 'n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20'

        for _, subscriber in ipairs(m.subscribers) do
            subscriber()
        end

        local color_name = colorscheme.name or vim.g.colors_name
        if file_readable(tmux_color_path) and readfile(tmux_color_path)[1] == color_name then
            return
        end

        system('echo -n ' .. color_name .. ' > ' .. tmux_color_path)
        if vim.env.TMUX then
            system 'tmux source ~/.tmux.conf'
        end

        m.load_terminal_colors()
    end
end

m.load_terminal_colors = function()
    local bg = vim.fn.synIDattr(vim.fn.hlID 'Normal', 'bg')
    if bg ~= '' then
        terminal_color.set_background_color(bg)
    end
end

return m
