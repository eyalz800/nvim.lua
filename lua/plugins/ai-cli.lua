local m = {}
local user = require 'user'
local cmd = require 'vim.cmd'.silent
local echo = require 'vim.echo'.echo
local executable = require 'vim.executable'.executable
local pin = require 'plugins.pin'

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local commands = {
    claude = { 'claude' },
    opencode = { 'opencode' },
}

local state = { buf = nil, job = nil }

local command = function()
    local name = user.settings.ai_cli or 'claude'
    return commands[name] or { name }
end

local width_fraction = function()
    return (user.settings.ai_cli_config or {}).width
end

local buf_valid = function()
    return state.buf ~= nil and vim.api.nvim_buf_is_valid(state.buf)
end

local find_win = function(buf, tabpage_only)
    if not buf or not vim.api.nvim_buf_is_valid(buf) then
        return nil
    end
    local wins = tabpage_only and vim.api.nvim_tabpage_list_wins(0) or vim.api.nvim_list_wins()
    for _, win in ipairs(wins) do
        if vim.api.nvim_win_is_valid(win) and
            vim.api.nvim_win_get_buf(win) == buf and
            vim.api.nvim_win_get_config(win).relative == ''
        then
            return win
        end
    end
end

local close_win = function(buf, tabpage_only)
    local win = find_win(buf, tabpage_only)
    while win do
        pin.unpin({ buf = buf, win = win })
        if not pcall(vim.api.nvim_win_close, win, true) then
            return
        end
        win = find_win(buf, tabpage_only)
    end
end

local start = function()
    local argv = command()

    if not executable(argv[1]) then
        echo('ai-cli: ' .. argv[1] .. ' is not executable')
        return false
    end

    local buf = vim.api.nvim_create_buf(false, true)
    local job = nil

    vim.api.nvim_buf_call(buf, function()
        job = vim.fn.jobstart(argv, { term = true, cwd = vim.fn.getcwd() })
    end)

    if not job or job <= 0 then
        echo('ai-cli: failed to start ' .. argv[1])
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
        return false
    end

    -- Keep the buffer and its job alive once the window is gone, so re-opening
    -- returns to the same session instead of starting a new one.
    vim.bo[buf].bufhidden = 'hide'
    vim.bo[buf].buflisted = false

    autocmd('termclose', {
        group = augroup('init.lua.ai-cli', { clear = true }),
        buffer = buf,
        callback = function(args)
            state.buf, state.job = nil, nil
            vim.schedule(function()
                close_win(args.buf)
                pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
            end)
        end,
    })

    vim.keymap.set('x', 'a', '<esc><cmd>startinsert<cr>', { silent = true, buffer = buf, nowait = true })

    state.buf, state.job = buf, job
    return true
end

m.is_open = function()
    return find_win(state.buf, true) ~= nil
end

m.open = function()
    local win = find_win(state.buf, true)
    if win then
        vim.api.nvim_set_current_win(win)
        vim.cmd.startinsert()
        return
    end

    if not buf_valid() and not start() then
        return
    end

    -- Measure the window we are about to split, not the whole screen, so an open
    -- file/code explorer only costs the split its own share of the space.
    local available = vim.api.nvim_win_get_width(vim.api.nvim_get_current_win())

    cmd 'vert rightb new'
    vim.bo.bufhidden = 'wipe'
    vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), state.buf)
    -- No 'Normal:NormalSB' here: unlike the explorer terminals this window is a
    -- main working area, so it uses the regular Normal background.
    vim.opt_local.winbar = ''
    vim.opt_local.cursorline = false
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'no'

    -- Plain vertical split otherwise: nvim already halves the window it split, so
    -- resize only when a fraction is configured. Note that 'horizontal wincmd ='
    -- must not be run here -- despite the name it equalizes widths, not heights.
    local fraction = width_fraction()
    if fraction then
        cmd('vertical resize ' .. math.floor(available * fraction))
    end

    pin.pin()
    vim.cmd.startinsert()
end

m.close = function()
    close_win(state.buf, true)
end

local toggle = function()
    local win = find_win(state.buf, true)
    if win and win == vim.api.nvim_get_current_win() then
        m.close()
    else
        m.open()
    end
end

m.toggle = function()
    if vim.api.nvim_get_mode().mode == 't' then
        vim.cmd.stopinsert()
        vim.schedule(toggle)
        return
    end
    toggle()
end

return m
