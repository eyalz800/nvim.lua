local m = {}
local v = require 'vim'
local echo = require 'vim.echo'.echo
local expand = v.fn.expand
local cmd = require 'vim.cmd'.silent
local file_readable = require 'vim.file_readable'.file_readable
local user = require 'user'

--local winwidth = v.fn.winwidth
local win_getid = v.fn.win_getid
local win_gotoid = v.fn.win_gotoid
local getqflist = v.fn.getqflist

local debugger = require 'plugins.debugger'

m.file = require 'plugins.file_explorer'
m.code = require 'plugins.code_explorer'

m.display_current_file = function()
    if m.file.is_open() and file_readable(expand '%') then
        m.file.open({ focus=false })
    end
    echo(v.fn.expand('%:p'))
end

m.display_current_directory = function()
    if m.file.is_open() then
        m.file.open_current_directory({ focus=false })
    end
    echo(v.fn.getcwd())
end

m.toggle = function()
    cmd 'cclose'
    if m.file.is_open() or m.code.is_open() then
        m.close()
        return
    end
    require 'plugins.quickfix'.open({ focus = false })
    m.file.open({ focus = false })
    m.code.open({ focus = false })
end

m.close = function()
    m.file.close()
    m.code.close()
    cmd 'cclose'
end

m.arrange = function()
    if user.settings.edge == 'edgy' then
        return
    end
    local cur_win = win_getid()
    local qf = getqflist({winid = 0}).winid

    if qf > 0 then
        win_gotoid(qf)
        cmd 'wincmd J'
        cmd('resize ' .. 10)
    end
    if m.code.is_open() then
        m.code.open({ focus = true })

        --local width = winwidth(0)
        cmd 'wincmd L'
        cmd('vertical resize ' .. 30)
    end
    if m.file.is_open() then
        m.file.open({ focus = true })

        --local width = winwidth(0)
        cmd 'wincmd H'
        cmd('vertical resize ' .. 30)
    end
    win_gotoid(cur_win)
    cmd 'wincmd ='
    debugger.arrange_if_open()
end

return m
