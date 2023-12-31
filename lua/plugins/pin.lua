local m = {}
local v = require 'vim'
local augroup = v.api.nvim_create_augroup
local autocmd = v.api.nvim_create_autocmd
local clear_autocmds = v.api.nvim_clear_autocmds

m.filetyeps = {
    'qf',
    'NvimTree',
    'Outline',
    'toggleterm',
    'fugitiveblame',
    'dapui_watches',
    'dapui_scopes',
    'dapui_stacks',
    'dapui_breakpoints',
    'dapui_console',
    'dap-repl',
}

local make_win_ref = function(buf)
    local success, win = pcall(v.api.nvim_open_win, buf, false, {
        relative = 'editor',
        width = 1,
        height = 2,
        col = 0,
        row = 0,
        style = 'minimal',
        noautocmd = true,
    })
    if success then
        v.w[win].pin_data = { buf = buf }
        return win
    end
end

local open_in_best_win = function(buf)
    for winnr = 1, v.fn.winnr '$' do
        local winid = v.fn.win_getid(winnr)
        if not v.w[winid].pin_data and v.api.nvim_win_get_config(winid or 0).relative == '' then
            v.cmd.wincmd({ count = winnr, args = { 'w' } })
            v.cmd.buffer({ args = { buf } })
            return
        end
    end
    v.fn.win_execute(v.fn.win_getid(1), string.format('vertical rightbelow sbuffer %d', buf))
    v.cmd.wincmd({ count = 2, args = { 'w' } })
end

local is_auto_deleted = function(buf)
    local bufhidden = v.bo[buf].bufhidden
    return bufhidden == 'unload' or bufhidden == 'delete' or bufhidden == 'wipe'
end

m.pin = function(opts)
    opts = opts or {}

    local buf = opts.buf or v.api.nvim_get_current_buf()
    local win = opts.win or v.api.nvim_get_current_win()

    local buf_pin_data = {
        win = win,
        name = v.api.nvim_buf_get_name(buf),
    }
    local win_pin_data = { buf = buf }

    v.b[buf].pin_data = buf_pin_data
    v.w[win].pin_data = win_pin_data

    local group = augroup('init.lua.pin.bufwinleave', { clear = false })
    clear_autocmds({ group = group, buffer = buf })
    autocmd('bufwinleave', {
        group = group,
        buffer = buf,
        callback = function(args)
            local pin_data = v.b[args.buf].pin_data
            if pin_data and not pin_data.closing then
                if is_auto_deleted(args.buf) then
                    pin_data.win_ref = make_win_ref(args.buf)
                end
                v.b[args.buf].pin_data = pin_data
            end
        end,
    })

    group = augroup('init.lua.pin.winclosed', { clear = false })
    clear_autocmds({ group = group, buffer = buf })
    autocmd('winclosed', {
        group = group,
        buffer = buf,
        callback = function(args)
            local pin_data = v.b[args.buf].pin_data
            if pin_data then
                pin_data.closing = true
                v.b[args.buf].pin_data = pin_data
            end
        end,
    })
end

m.unpin = function(opts)
    opts = opts or {}

    local buf = opts.buf or v.api.nvim_get_current_buf()
    local win = opts.win or v.api.nvim_get_current_win()

    local group = augroup('init.lua.pin.bufwinleave', { clear = false })
    clear_autocmds({ group = group, buffer = buf })

    group = augroup('init.lua.pin.winclosed', { clear = false })
    clear_autocmds({ group = group, buffer = buf })

    v.b[buf].pin_data = nil
    v.w[win].pin_data = nil
end

m.setup = function()
    autocmd('bufenter', {
        group = augroup('init.lua.pin.bufenter', {}),
        callback = function(args)
            local win_pin_data = v.w.pin_data
            local buf = args.buf

            if win_pin_data then
                if buf == win_pin_data.buf then
                    return
                end

                local buf_pin_data = nil
                if not v.api.nvim_buf_is_valid(win_pin_data.buf) then
                    win_pin_data = nil
                else
                    buf_pin_data = v.b[win_pin_data.buf].pin_data
                    if not buf_pin_data then
                        win_pin_data = nil
                    end
                end

                if not win_pin_data then
                    v.w.pin_data = nil
                else
                    local win_ref = nil
                    if is_auto_deleted(buf) then
                        win_ref = make_win_ref(buf)
                        if not win_ref then
                            if buf_pin_data.win_ref then
                                pcall(v.api.nvim_win_close, buf_pin_data.win_ref, true)
                                v.b[win_pin_data.buf].pin_data.win_ref = nil
                            end
                            return
                        end
                    end

                    local success, _ = pcall(v.api.nvim_win_set_buf, buf_pin_data.win, win_pin_data.buf)
                    if buf_pin_data.win_ref then
                        pcall(v.api.nvim_win_close, buf_pin_data.win_ref, true)
                        v.b[win_pin_data.buf].pin_data.win_ref = nil
                    end

                    if success then
                        pcall(open_in_best_win, buf)
                    end

                    if win_ref then
                        pcall(v.api.nvim_win_close, win_ref, true)
                    end
                    return
                end
            end

            local buf_pin_data = v.b[buf].pin_data
            if buf_pin_data then
                if not v.api.nvim_win_is_valid(buf_pin_data.win) then
                    win_pin_data = { buf = buf }
                    v.w.pin_data = win_pin_data
                    buf_pin_data.win = v.api.nvim_get_current_win()
                    v.b[buf].pin_data = buf_pin_data
                end
            else
                local buf_ft = v.bo[buf].filetype
                for _, ft in ipairs(m.filetyeps) do
                    if buf_ft == ft then
                        m.pin({buf=buf, win=v.api.nvim_get_current_win()})
                        break
                    end
                end
            end
        end,
    })
end

return m
