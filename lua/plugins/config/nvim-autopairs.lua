local m = {}

m.config = function()
    return {
        disable_filetype = { 'TelescopePrompt', 'spectre_panel' },
        disable_in_macro = true,
        disable_in_visualblock = false,
        disable_in_replace_mode = true,
        ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
        enable_moveright = true,
        enable_afterquote = false,
        enable_check_bracket_line = true,
        enable_bracket_in_quote = false,
        enable_abbr = false,
        break_undo = true,
        check_ts = false,
        map_cr = true,
        map_bs = true,
        map_c_h = false,
        map_c_w = false,
    }
end

m.setup = function()
    local cmp_loaded, cmp = pcall(require, 'cmp')
    if cmp_loaded then
        local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
        cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end
end

return m
