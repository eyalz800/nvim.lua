local m = {}
local v = require 'vim'
local echo = require 'vim.echo'.echo
local expand = v.fn.expand
local cmd = require 'vim.cmd'.silent
local file_readable = require 'vim.file_readable'.file_readable

local winwidth = v.fn.winwidth
local win_getid = v.fn.win_getid
local win_gotoid = v.fn.win_gotoid
local getqflist = v.fn.getqflist

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

m.close = function()
    m.file.close()
    m.code.close()
    cmd 'cclose'
end

m.arrange = function()
    local cur_win = win_getid()
    local qf = getqflist({winid = 0}).winid
    local code = m.code.is_open()

    if qf > 0 then
        win_gotoid(qf)
        cmd 'wincmd J'
    end
    if code then
        m.code.close()
    end
    if m.file.is_open() then
        m.file.open({ focus = true })

        local width = winwidth(0)
        cmd 'wincmd H'
        cmd('vertical resize ' .. width)
    end
    win_gotoid(cur_win)
    if code then
        m.code.open({ focus = false })
    end
end

return m
