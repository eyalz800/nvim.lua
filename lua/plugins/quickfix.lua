local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent
local user = require 'user'
local file_explorer = require 'plugins.file_explorer'
local code_explorer = require 'plugins.code_explorer'

local winwidth = v.fn.winwidth
local win_getid = v.fn.win_getid
local win_gotoid = v.fn.win_gotoid

local quickfix_expand = user.settings.quickfix_expand

m.on_open = function()
    v.keymap.set('n', 'q', ':<C-u>q<cr>', { silent=true, buffer=true })
    if not quickfix_expand then
        return
    end

    local qf = win_getid()
    cmd 'wincmd J'

    v.defer_fn(function()
        if code_explorer.is_open() then
            code_explorer.close()
        end
        if file_explorer.is_open() then
            cmd 'wincmd p'
            local cur_win = win_getid()
            file_explorer.open()
            local width = winwidth(0)
            cmd 'wincmd H'
            cmd('vertical resize ' .. width)
            win_gotoid(cur_win)
            win_gotoid(qf)
        end
    end, 0)
end

return m
