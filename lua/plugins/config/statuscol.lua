local m = {}
local v = require 'vim'
local debugger = require 'plugins.debugger'
local user = require 'user'

local curwin = v.api.nvim_get_current_win

m.config = function()
    local builtin = require 'statuscol.builtin'

    local toggle_breakpoint = function(args)
        if args.button == 'l' then
            debugger.toggle_breakpoint()
        end
    end

    local line_number_setting = user.settings.line_number

    return {
        setopt = true,
        thousands = false,
        relculright = true,
        ft_ignore = { 'nerdtree', 'tagbar', 'NvimTree', 'Outline', 'VimspectorPrompt' },
        bt_ignore = { 'prompt', 'terminal' },
        segments = {
            { text = { '%C' }, click = 'v:lua.ScFa' },
            { text = { '%s' }, click = 'v:lua.ScSa' },
            {
                text = { '%=%{v:lnum}' },
                click = 'v:lua.ScLa',
                condition = {
                    line_number_setting.together,
                },
            },
            {
                text = { ' ', builtin.lnumfunc, ' ' },
                click = 'v:lua.ScLa',
                condition = {
                    function(args) return v.o.relativenumber and curwin() == args.win end,
                    function(args) return v.o.relativenumber and curwin() == args.win end,
                    builtin.notempty,
                },
            },
        },
        clickmod = 'c',
        clickhandlers = {
            Lnum                    = toggle_breakpoint,
            FoldClose               = builtin.foldclose_click,
            FoldOpen                = builtin.foldopen_click,
            FoldOther               = builtin.foldother_click,
            DapBreakpointRejected   = builtin.toggle_breakpoint,
            DapBreakpoint           = builtin.toggle_breakpoint,
            DapBreakpointCondition  = builtin.toggle_breakpoint,
            DiagnosticSignError     = builtin.diagnostic_click,
            DiagnosticSignHint      = builtin.diagnostic_click,
            DiagnosticSignInfo      = builtin.diagnostic_click,
            DiagnosticSignWarn      = builtin.diagnostic_click,
            GitSignsTopdelete       = builtin.gitsigns_click,
            GitSignsUntracked       = builtin.gitsigns_click,
            GitSignsAdd             = builtin.gitsigns_click,
            GitSignsChange          = builtin.gitsigns_click,
            GitSignsChangedelete    = builtin.gitsigns_click,
            GitSignsDelete          = builtin.gitsigns_click,
            gitsigns_extmark_signs_ = builtin.gitsigns_click,
            vimspectorBP            = toggle_breakpoint
        },
    }
end

return m
