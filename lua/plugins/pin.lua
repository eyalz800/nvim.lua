local m = {}
local v = require 'vim'
local augroup = v.api.nvim_create_augroup
local autocmd = v.api.nvim_create_autocmd
local clear_autocmds = v.api.nvim_clear_autocmds

m.filetyeps = {
    'qf',
    'fugitiveblame',
    'NvimTree',
    'Outline',
}

local make_win_ref = function(buf)
    local win = v.api.nvim_open_win(buf, false, {
        relative = 'editor',
        width = 1,
        height = 1,
        col = 0,
        row = 0,
        style = 'minimal',
        noautocmd = true,
    })
    v.w[win].pin_data = { buf = buf }
    return win
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
            if not pin_data.closing then
                pin_data.win_ref = make_win_ref(args.buf)
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
            pin_data.closing = true
            v.b[args.buf].pin_data = pin_data
        end,
    })
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

                local buf_pin_data = v.b[win_pin_data.buf].pin_data
                if not buf_pin_data.win_ref then
                    return
                end

                local win_ref = make_win_ref(buf)
                v.api.nvim_win_set_buf(buf_pin_data.win, win_pin_data.buf)
                v.api.nvim_win_close(buf_pin_data.win_ref, true)
                buf_pin_data.win_ref = nil

                open_in_best_win(buf)
                v.api.nvim_win_close(win_ref, true)
                return
            end

            local buf_pin_data = v.b[buf].pin_data
            if buf_pin_data then
                win_pin_data = { buf = buf }
                v.w.pin_data = win_pin_data

                buf_pin_data.win = v.api.nvim_get_current_win()
                v.b[buf].pin_data = buf_pin_data
            else
                local buf_ft = v.bo[buf].filetype
                for _, ft in ipairs(m.filetyeps) do
                    if buf_ft == ft then
                        m.pin({buf=buf, win=v.api.nvim_get_current_win()})
                        win_pin_data = { buf = buf }
                        buf_pin_data = v.b[buf].pin_data
                        break
                    end
                end
            end
        end,
    })
end

return m
