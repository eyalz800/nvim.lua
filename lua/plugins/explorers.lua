local m = {}
local echo = require 'vim.echo'.echo
local expand = vim.fn.expand
local cmd = require 'vim.cmd'.silent
local file_readable = require 'vim.file_readable'.file_readable
local pin = require 'plugins.pin'
local user = require 'user'

local win_getid = vim.fn.win_getid
local win_gotoid = vim.fn.win_gotoid
local getqflist = vim.fn.getqflist
local getcwd = vim.fn.getcwd

local debugger = require 'plugins.debugger'
local code_explorer_auto_open_min_columns = user.settings.code_explorer_config.auto_open_min_columns or 0

m.file = require 'plugins.file_explorer'
m.code = require 'plugins.code_explorer'
m.terminals = {}

m.display_current_file = function()
    if m.file.is_open() and file_readable(expand '%') then
        m.file.open({ focus=false })
    end
    echo(expand '%:p')
end

m.display_current_directory = function()
    if m.file.is_open() then
        m.file.open_current_directory({ focus=false })
    end
    echo(getcwd())
end

m.toggle = function()
    vim.cmd.cclose()
    if m.file.is_open() or m.code.is_open() then
        m.close()
        m.arrange()
        return
    end
    require 'plugins.quickfix'.open({ focus = false })
    m.open_terminal({ focus = false })
    m.file.open({ focus = false })
    if code_explorer_auto_open_min_columns <= vim.o.columns then
        m.code.open({ focus = false })
    end
    m.arrange()
end

m.close = function()
    m.file.close()
    m.code.close()
    for _, terminal in ipairs(m.terminals) do
        if vim.api.nvim_win_is_valid(terminal) then
            local buffer = vim.api.nvim_win_get_buf(terminal)
            if vim.api.nvim_buf_is_valid(buffer) then
                vim.bo[buffer].bufhidden = 'wipe'
            end
            vim.api.nvim_win_close(terminal, true)
        end
    end
    m.terminals = {}
    vim.cmd.cclose()
    m.arrange()
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
        vim.cmd.wincmd 'J'
        vim.cmd.resize(10)
    end
    for terminal_index, terminal in ipairs(m.terminals) do
        if vim.api.nvim_win_is_valid(terminal) and
            (vim.api.nvim_win_get_tabpage(terminal) == vim.api.nvim_get_current_tabpage() or
                vim.api.nvim_get_current_tabpage() == 1)
        then
            term_buf = vim.api.nvim_win_get_buf(terminal)
            if vim.api.nvim_buf_is_valid(term_buf) then
                pin.unpin({ buf = term_buf, win = terminal })
                if terminal_index ~= 1 or qf > 0 then
                    cmd 'vert rightb split'
                    vim.bo.bufhidden = 'wipe'
                else
                    cmd 'below 10new'
                    cmd 'wincmd J'
                    vim.bo.bufhidden = 'wipe'
                end
                local term_win = vim.api.nvim_get_current_win()
                vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), term_buf)
                vim.bo.bufhidden = 'wipe'
                vim.opt_local.winhighlight = 'Normal:NormalSB,WinBar:NormalSB'
                vim.opt_local.winbar = ''
                vim.opt_local.cursorline = false
                vim.api.nvim_win_close(terminal, true)
                pin.pin()
                m.terminals[terminal_index] = term_win
                if cur_win == terminal then
                    cur_win = term_win
                end
                vim.cmd.resize(10)
            end
        end
    end
    if m.code.is_open() then
        m.code.open({ focus = true })

        --local width = winwidth(0)
        vim.cmd.wincmd 'L'
        cmd('vertical resize ' .. 30)
    end
    if m.file.is_open() then
        m.file.open({ focus = true })

        --local width = winwidth(0)
        vim.cmd.wincmd 'H'
        cmd('vertical resize ' .. 30)
    end
    win_gotoid(cur_win)
    cmd 'horizontal wincmd ='
    if debugger.is_ui_open() then
        debugger.reset_ui()
    end
    if vim.bo.buftype ~= 'terminal' then
        vim.cmd.stopinsert()
    end
end

m.open_terminal = function(options)
    options = options or {}
    options.focus = options.focus == nil and true or options.focus

    local return_win = nil
    if not options.focus then
        return_win = vim.api.nvim_get_current_win()
    end

    local below_win = nil

    if not options.new then
        for _, terminal in ipairs(m.terminals) do
            if vim.api.nvim_win_is_valid(terminal) then
                vim.api.nvim_set_current_win(terminal)
                return
            end
        end

        m.terminals = {}
    else
        for i = #m.terminals, 1, -1 do
            local terminal = m.terminals[i]
            if vim.api.nvim_win_is_valid(terminal) then
                below_win = terminal
                vim.api.nvim_set_current_win(terminal)
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

    vim.opt_local.winhighlight = 'Normal:NormalSB,WinBar:NormalSB'
    vim.opt_local.winbar = ''
    vim.opt_local.cursorline = false
    vim.bo.buflisted = false
    vim.bo.bufhidden = 'wipe'
    vim.keymap.set('x', 'a', '<esc><cmd>startinsert<cr>', { silent = true, buffer = true, nowait = true })
    vim.keymap.set('t', '<c-w>v', function()
        local cur_win = vim.api.nvim_get_current_win()
        local terminal_index = #m.terminals
        for index, terminal in ipairs(m.terminals) do
            if terminal == cur_win then
                terminal_index = index
            end
        end
        m.open_terminal({new = true, focus = true})
        vim.api.nvim_set_current_win(m.terminals[terminal_index + 1])
    end, { silent = true, buffer = true, nowait = true })

    table.insert(m.terminals, vim.api.nvim_get_current_win())
    pin.pin()

    m.arrange()

    if not options.focus then
        vim.api.nvim_set_current_win(return_win)
    else
        vim.cmd.startinsert()
    end
end

return m
