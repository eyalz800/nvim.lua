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
m.terminals = {}

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
    for _, terminal in ipairs(m.terminals) do
        local buffer = v.api.nvim_win_get_buf(terminal)
        if v.api.nvim_buf_is_valid(buffer) then
            v.bo[buffer].bufhidden = 'wipe'
        end
        v.api.nvim_win_close(terminal, true)
    end
    m.terminals = {}
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
    for terminal_index, terminal in ipairs(m.terminals) do
        if v.api.nvim_win_is_valid(terminal) and
            (v.api.nvim_win_get_tabpage(terminal) == v.api.nvim_get_current_tabpage() or
                v.api.nvim_get_current_tabpage() == 1)
        then
            term_buf = v.api.nvim_win_get_buf(terminal)
            if v.api.nvim_buf_is_valid(term_buf) then
                pin.unpin({ buf = term_buf, win = terminal })
                if terminal_index ~= 1 or qf > 0 then
                    cmd 'vert rightb split'
                    v.bo.bufhidden = 'wipe'
                else
                    cmd 'below 10new'
                    cmd 'wincmd J'
                    v.bo.bufhidden = 'wipe'
                end
                local term_win = v.api.nvim_get_current_win()
                v.api.nvim_win_set_buf(v.api.nvim_get_current_win(), term_buf)
                v.bo.bufhidden = 'wipe'
                v.wo.winhighlight = 'Normal:NormalSB,WinBar:NormalSB'
                v.wo.winbar = ''
                v.wo.cursorline = false
                v.api.nvim_win_close(terminal, true)
                pin.pin()
                m.terminals[terminal_index] = term_win
                if cur_win == terminal then
                    cur_win = term_win
                end
                v.cmd.resize(10)
            end
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
    if v.bo.buftype ~= 'terminal' then
        v.cmd.stopinsert()
    end
end

m.open_terminal = function(options)
    options = options or {}
    options.focus = options.focus == nil and true or options.focus

    local return_win = nil
    if not options.focus then
        return_win = v.api.nvim_get_current_win()
    end

    local below_win = nil

    if not options.new then
        for _, terminal in ipairs(m.terminals) do
            if v.api.nvim_win_is_valid(terminal) then
                v.api.nvim_set_current_win(terminal)
                return
            end
        end

        m.terminals = {}
    else
        for i = #m.terminals, 1, -1 do
            local terminal = m.terminals[i]
            if v.api.nvim_win_is_valid(terminal) then
                below_win = terminal
                v.api.nvim_set_current_win(terminal)
            end
        end
    end

    if not below_win then
        local qf = getqflist({winid = 0}).winid

        if qf > 0 then
            win_gotoid(qf)
            below_win = qf
        end
    end

    if below_win then
        cmd 'vert rightb new +terminal'
    else
        cmd 'below 10new +terminal'
    end

    v.wo.winhighlight = 'Normal:NormalSB,WinBar:NormalSB'
    v.wo.winbar = ''
    v.wo.cursorline = false
    v.bo.buflisted = false
    v.bo.bufhidden = 'wipe'
    v.keymap.set('x', 'a', '<esc><cmd>startinsert<cr>', { silent = true, buffer = true, nowait = true })
    v.keymap.set('t', '<c-w>v', function()
        local cur_win = v.api.nvim_get_current_win()
        local terminal_index = #m.terminals
        for index, terminal in ipairs(m.terminals) do
            if terminal == cur_win then
                terminal_index = index
            end
        end
        m.open_terminal({new = true, focus = true})
        v.api.nvim_set_current_win(m.terminals[terminal_index + 1])
    end, { silent = true, buffer = true, nowait = true })

    table.insert(m.terminals, v.api.nvim_get_current_win())
    pin.pin()

    m.arrange()

    if not options.focus then
        v.api.nvim_set_current_win(return_win)
    else
        v.cmd.startinsert()
    end
end

return m
