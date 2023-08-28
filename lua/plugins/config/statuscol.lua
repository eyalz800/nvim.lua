local m = {}
local v = require 'vim'
local debugger = require 'plugins.debugger'
local user = require 'user'
local git = require 'plugins.git'

local curwin = v.api.nvim_get_current_win

m.config = function()
    local builtin = require 'statuscol.builtin'

    local toggle_breakpoint = function(args)
        if args.button == 'l' then
            debugger.toggle_breakpoint()
        end
    end

    local line_action = function(args)
        if args.button == 'r' or (args.button == 'l' and args.mods:find 'c') then
            git.git_blame_current_line()
        elseif args.button == 'l' then
            return debugger.toggle_breakpoint()
        end
    end

    local line_number_setting = user.settings.line_number

    return {
        setopt = true,
        thousands = false,
        relculright = true,
        ft_ignore = { 'nerdtree', 'tagbar', 'NvimTree', 'Outline', 'VimspectorPrompt', 'fugitiveblame' },
        bt_ignore = { 'prompt', 'terminal' },
        segments = {
            { text = { '%C' }, click = 'v:lua.ScFa' },
            { text = { '%s' }, click = 'v:lua.ScSa' },
            {
                text = { '%=%{v:lnum} ' },
                click = 'v:lua.ScLa',
                condition = { line_number_setting.together, },
            },
            {
                text = { function(args) return builtin.lnumfunc(args) .. ' ' end },
                click = 'v:lua.ScLa',
                condition = {
                    function(args)
                        return not line_number_setting.together or (v.o.relativenumber and curwin() == args.win)
                    end,
                },
            },
        },
        clickmod = 'c',
        clickhandlers = {
            Lnum                    = line_action,
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
