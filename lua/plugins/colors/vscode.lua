local m = {}
local v = require 'vim'
local user = require 'user'

m.set_background = function(color_name)
    if color_name == 'vscode-light' then
        v.opt.background = 'light'
    else
        v.opt.background = 'dark'
    end
end

m.config = function()
    local settings = user.settings.colorscheme_settings

    return {
        -- style = 'light'

        transparent = settings.transparent,

        italic_comments = false,
        disable_nvimtree_bg = false,

        color_overrides = {},
        group_overrides = {}
    }
end

m.apply = function()
    if v.o.background == 'dark' then
        v.env.BAT_THEME = 'Monokai Extended Origin'
    else
        v.env.BAT_THEME = 'Monokai Extended Light'
    end

    if user.settings.lsp == 'coc' then
        v.cmd [=[
            hi! link CocUnusedHighlight DiagnosticUnderlineWarn
            hi! DiagnosticVirtualTextError guibg=NONE
            hi! DiagnosticVirtualTextWarn guibg=NONE
            hi! DiagnosticVirtualTextHint guibg=NONE
            hi! DiagnosticVirtualTextInfo guibg=NONE
        ]=]
    elseif user.settings.lsp == 'nvim' then
        v.cmd [=[
            hi! link DiagnosticUnnecessary DiagnosticUnderlineWarn
            hi! DiagnosticVirtualTextError guibg=NONE
            hi! DiagnosticVirtualTextWarn guibg=NONE
            hi! DiagnosticVirtualTextHint guibg=NONE
            hi! DiagnosticVirtualTextInfo guibg=NONE
        ]=]
    end

    if user.settings.finder == 'fzf' or user.settings.finder == 'fzf-lua' then
        v.g.fzf_colors = {
            fg = { 'fg', 'Normal' },
            bg = { 'bg', 'Normal' },
            hl = { 'fg', 'SpecialKey' },
            ['fg+'] = { 'fg', 'CursorLine' },
            ['bg+'] = { 'bg', 'CursorLine' },
            ['hl+'] = { 'fg', 'String' },
            info = { 'fg', 'Comment' },
            border = { 'fg', 'Ignore' },
            prompt = { 'fg', 'StorageClass' },
            pointer = { 'fg', 'Error' },
            marker = { 'fg', 'Keyword' },
            spinner = { 'fg', 'Label' },
            header = { 'fg', 'Comment' }
        }
    end

    return true
end

return m

