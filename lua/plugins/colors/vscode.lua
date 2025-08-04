local m = {}
local user = require 'user'
local nvim_set_hl = vim.api.nvim_set_hl

m.name = 'vscode'

m.setup = function()
    require 'vscode'.setup(m.config())
end

m.config = function()
    local settings = user.settings.colorscheme_settings
    local color = require 'vscode.colors' .get_colors()

    local options = {
        transparent = settings.transparent,

        italic_comments = false,
        disable_nvimtree_bg = false,

        color_overrides = {},
        group_overrides = {
            NormalFloat = { fg = color.vscFront, bg = color.vscBack },
            BufferLineFill = { fg = color.vscBack },
            --NvimTreeWinSeparator = { fg = color.vscLeftDark, bg = color.vscLeftDark },
            NvimTreeCursorLineNr = { fg = color.vscPopupFront, bg = color.vscLeftDark },
            NvimTreeLineNr = { fg = color.vscLineNumber, bg = color.vscLeftDark },
            BufferLineOffsetSeparator = { fg = color.vscLeftDark, bg = color.vscLeftDark },
            MatchParen = { fg = color.vscBlueGreen, bg = color.vscBack },
            WarningMsg = { fg = color.vscUiOrange },
            DiagnosticWarn = { fg = color.vscUiOrange },
            InitLuaDebugPC = { fg = color.vscGreen },
            DiagnosticUnderlineTextError = { fg = color.vscRed },
            DiagnosticUnderlineTextWarn = { fg = color.vscUiOrange },
            DiagnosticUnderlineTextHint = { fg = color.vscBlue },
            DiagnosticUnderlineTextInfo = { fg = color.vscBlue },
            MinuetVirtualText = { fg = color.vscSuggestion, bg = color.vscBack },
            ['@keyword.function.lua'] = { fg = color.vscPink },
            ['@string.escape'] = { fg = color.vscYellowOrange },
            ['@conditional.ternary'] = { fg = color.vscFront },
            ['@punctuation.delimiter'] = { fg = color.vscFront },
            ['@constructor.lua'] = { fg = color.vscFront },
            ['@variable.builtin'] = { fg = color.vscBlue },
        }
    }

    if user.settings.bar == 'barbecue' then
        options.group_overrides.BufferLineFill = nil
    end

    return options
end

m.pre_apply = function(colors_name)
    vim.opt.background = 'dark'
    vim.env.BAT_THEME = 'Monokai Extended Origin'
end

m.apply = function(colors_name)
    m.name = colors_name

    local color = require 'vscode.colors' .get_colors()

    vim.cmd([=[
        hi! DiagnosticUnderlineWarn guisp=]=] .. color.vscUiOrange .. [=[
    ]=])

    if user.settings.lsp == 'nvim' then
        nvim_set_hl(0, 'DiagnosticUnnecessary', { link = 'DiagnosticUnderlineWarn' })
    elseif user.settings.lsp == 'coc' then
        nvim_set_hl(0, 'CocUnusedHighlight', { link = 'DiagnosticUnderlineWarn' })
    end

    if user.settings.finder == 'fzf' or user.settings.finder == 'fzf-lua' then
        vim.g.fzf_colors = {
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
end

return m
