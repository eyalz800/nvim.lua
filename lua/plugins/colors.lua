local m = {}
local user = require 'user'
local cmd = require 'vim.cmd'.silent
local file_readable = require 'vim.file-readable'.file_readable
local terminal_color = require 'plugins.terminal-color'

local readfile = vim.fn.readfile
local expand = vim.fn.expand
local system = vim.fn.system

local tmux_color_path = expand '~/.tmux.color'

m.subscribers = {}

m.subscribe = function(subscriber)
    table.insert(m.subscribers, subscriber)
end

m.setup = function()
    vim.api.nvim_create_autocmd('colorschemepre', {
        group = vim.api.nvim_create_augroup('init.lua.colorscheme-pre', {}),
        callback = function(event)
            m.pre_switch_color(event.match)
        end
    })

    vim.api.nvim_create_autocmd('colorscheme', {
        group = vim.api.nvim_create_augroup('init.lua.colorscheme', {}),
        callback = function(event)
            m.post_switch_color(event.match)
        end
    })

    vim.api.nvim_create_autocmd('user', {
        pattern = 'VeryLazy',
        group = vim.api.nvim_create_augroup('init.lua.terminal-color', {}),
        callback = m.load_terminal_colors
    })
end

m.set = function()
    cmd('colorscheme ' .. user.settings.colorscheme)
end

m.pre_switch_color = function(colors_name)
    local success, colorscheme = pcall(require, 'plugins.colors.' .. colors_name)
    if success and colorscheme.pre_apply then
        colorscheme.pre_apply()
    end
end

m.post_switch_color = function(colors_name)
    local success, colorscheme = pcall(require, 'plugins.colors.' .. colors_name)
    if success and colorscheme.apply then
        colorscheme.apply(colors_name)

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
