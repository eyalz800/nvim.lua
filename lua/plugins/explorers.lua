local m = {}
local v = require 'vim'
local echo = require 'vim.echo'.echo
local expand = v.fn.expand
local cmd = require 'vim.cmd'.silent
local file_readable = require 'vim.file_readable'.file_readable
local pin = require 'plugins.pin'
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
    v.cmd.cclose()
    if m.file.is_open() or m.code.is_open() then
        m.close()
        m.arrange()
        return
    end
    require 'plugins.quickfix'.open({ focus = false })
    m.open_terminal({ focus = false })
    m.file.open({ focus = false })
    m.code.open({ focus = false })
    m.arrange()
end

m.close = function()
    m.file.close()
    m.code.close()
    if m.terminal and v.api.nvim_win_is_valid(m.terminal) then
        v.api.nvim_win_close(m.terminal, true)
        m.terminal = nil
    end
    v.cmd.cclose()
end

m.arrange = function()
    if user.settings.edge == 'edgy' then
        return
    end
    local term_buf = nil
    local cur_win = win_getid()
    local qf = getqflist({winid = 0}).winid

    if qf > 0 then
        win_gotoid(qf)
        v.cmd.wincmd 'J'
        v.cmd.resize(10)
    end
    if m.terminal and v.api.nvim_win_is_valid(m.terminal) and
        (v.api.nvim_win_get_tabpage(m.terminal) == v.api.nvim_get_current_tabpage() or
            v.api.nvim_get_current_tabpage() == 1)
    then
        term_buf = v.api.nvim_win_get_buf(m.terminal)
        if v.api.nvim_buf_is_valid(term_buf) then
            pin.unpin({ buf = term_buf, win = m.terminal })
            if qf > 0 then
                cmd 'vert rightb split'
                v.bo.bufhidden = 'wipe'
            else
                cmd 'below 10new'
                cmd 'wincmd J'
                v.bo.bufhidden = 'wipe'
            end
            local term_win = v.api.nvim_get_current_win()
            v.api.nvim_win_set_buf(v.api.nvim_get_current_win(), term_buf)
            v.wo.winhighlight = 'Normal:NormalSB,WinBar:NormalSB'
            v.wo.winbar = ''
            v.wo.cursorline = false
            v.api.nvim_win_close(m.terminal, true)
            pin.pin()
            m.terminal = term_win
            v.cmd.resize(10)
        end
    end
    if m.code.is_open() then
        m.code.open({ focus = true })

        --local width = winwidth(0)
        v.cmd.wincmd 'L'
        cmd('vertical resize ' .. 30)
    end
    if m.file.is_open() then
        m.file.open({ focus = true })

        --local width = winwidth(0)
        v.cmd.wincmd 'H'
        cmd('vertical resize ' .. 30)
    end
    win_gotoid(cur_win)
    cmd 'horizontal wincmd ='
    debugger.arrange_if_open()
end

m.open_terminal = function(options)
    options = options or { focus=true }

    if m.terminal and v.api.nvim_win_is_valid(m.terminal) then
        v.api.nvim_set_current_win(m.terminal)
        return
    end

    local return_win = nil
    if not options.focus then
        return_win = v.api.nvim_get_current_win()
    end

    local qf = getqflist({winid = 0}).winid

    if qf > 0 then
        win_gotoid(qf)
        cmd 'vert rightb new +terminal'
    else
        cmd 'below 10new +terminal'
    end

    v.wo.winhighlight = 'Normal:NormalSB,WinBar:NormalSB'
    v.wo.winbar = ''
    v.wo.cursorline = false
    v.bo.buflisted = false
    v.keymap.set('x', 'a', '<esc><cmd>startinsert<cr>', { silent = true, buffer = true, nowait = true })
    m.terminal = v.api.nvim_get_current_win()
    pin.pin()

    if not options.focus then
        v.api.nvim_set_current_win(return_win)
    else
        v.cmd.startinsert()
    end
end

return m
