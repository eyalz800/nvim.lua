local m = {}
local v = require 'vim'
local user = require 'user'

if user.settings.float_term == 'floaterm' then
    local cmd = require 'vim.cmd'.silent
    m.open_floating_terminal = function(command)
        cmd('FloatermNew --height=0.9 --width=0.9 --autoclose=2 ' .. command)
    end
else
    local lazy = require 'lazy.util'
    local float_term = function(cmd, opts)
        opts = opts or {}

        local float = lazy.float(opts)
        v.fn.termopen(cmd, v.tbl_isempty(opts) and v.empty_dict() or opts)
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

return m
