local m = {}
local v = require 'vim'
local user = require 'user'
local cmd = require 'vim.cmd'.silent

if user.settings.float_term == 'floaterm' then
    m.open_floating_terminal = function(command)
        cmd('FloatermNew --height=0.9 --width=0.9 --autoclose=2 ' .. command)
    end
else
    local lazy = require 'lazy.util'
    local float_term = function(command, opts)
        opts = opts or {}

        local float = lazy.float(opts)
        v.fn.termopen(command, v.tbl_isempty(opts) and v.empty_dict() or opts)
        if opts.interactive ~= false then
            v.cmd.startinsert()
            v.api.nvim_create_autocmd("TermClose", {
                once = true,
                buffer = float.buf,
                callback = function()
                    float:close({ wipe = true })
                    v.cmd.checktime()
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
    v.wo.winhighlight = 'Normal:NormalSB,WinBar:NormalSB'
    v.wo.winbar = ''
    v.bo.buflisted = false
    v.cmd.startinsert()
end

m.open_below = function()
    cmd 'below 10new +terminal'
    v.wo.winhighlight = 'Normal:NormalSB,WinBar:NormalSB'
    v.wo.winbar = ''
    v.bo.buflisted = false
    v.cmd.startinsert()
end

return m
