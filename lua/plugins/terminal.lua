local m = {}
local user = require 'user'
local cmd = require 'vim.cmd'.silent
local explorers = require 'plugins.explorers'

if user.settings.float_term == 'floaterm' then
    m.open_floating_terminal = function(command)
        cmd('FloatermNew --height=0.9 --width=0.9 --autoclose=2 ' .. command)
    end
else
    local lazy = require 'lazy.util'
    local float_term = function(command, opts)
        opts = opts or {}

        local float = lazy.float(opts)
        vim.fn.termopen(command, vim.tbl_isempty(opts) and vim.empty_dict() or opts)
        if opts.interactive ~= false then
            vim.cmd.startinsert()
            vim.api.nvim_create_autocmd("TermClose", {
                once = true,
                buffer = float.buf,
                callback = function()
                    float:close({ wipe = true })
                    vim.cmd.checktime()
                end,
            })
        end
        return float
    end

    m.open_floating_terminal = function(command)
        float_term(command, { size = { width = 0.89, height = 0.82, }, border = 'rounded'  })
    end
end

m.open_split = function()
    cmd 'vert rightb new +terminal'
    vim.opt_local.winhighlight = 'Normal:NormalSB,WinBar:NormalSB'
    vim.opt_local.winbar = ''
    vim.opt_local.cursorline = false
    vim.bo.buflisted = false
    vim.bo.bufhidden = 'wipe'
    vim.keymap.set('x', 'a', '<esc><cmd>startinsert<cr>', { silent = true, buffer = true, nowait = true })
    vim.cmd.startinsert()
end

m.open_below = function()
    explorers.open_terminal()
end

m.split_below = function()
    explorers.open_terminal({ new = true })
end

return m
