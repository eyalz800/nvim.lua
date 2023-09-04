local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent
local explorers = require 'plugins.explorers'
local user = require 'user'
local terminal = require 'plugins.terminal'

local win_getid = v.fn.win_getid
local win_gotoid = v.fn.win_gotoid
local getqflist = v.fn.getqflist

m.open = function(options)
    options = options or {}

    local return_win = win_getid()

    local qf_winid = getqflist({ winid = 0 }).winid
    if qf_winid > 0 then
        if options.focus then
            win_gotoid(qf_winid)
        end
        return
    end

    cmd 'below copen'

    if options.focus == false then
        win_gotoid(return_win)
    end

    if options.expand and user.settings.quickfix_expand then
        explorers.arrange()
    end
end

m.map_open = function()
    m.open({ focus = true, expand = true })
end

m.on_open = function()
    v.o.relativenumber = false
    v.keymap.set('n', 'q', ':<C-u>q<cr>', { silent=true, buffer=true })
    v.keymap.set('n', 'a', explorers.arrange, { silent=true, buffer=true })
    v.keymap.set('n', 'C', terminal.open_split, { silent = true, buffer = true })
end

return m
