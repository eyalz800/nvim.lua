local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent
local user = require 'user'

m.apply = function()
    if v.o.background == 'light' then
        v.opt.background = 'dark'
        v.schedule(function() cmd 'color tokyonight' end)
        return false
    end

    local settings = user.settings.colorscheme_settings
    v.g.tokyonight_italic_keywords = 0
    v.g.tokyonight_italic_comments = 0
    if settings.tokyonight.style then
        v.g.tokyonight_style = settings.tokyonight.style
    end

    local tokyonight_transparent

    if settings.transparent then
        tokyonight_transparent = settings.transparent
    else
        tokyonight_transparent = false
    end

    v.env.BAT_THEME = 'Monokai Extended Origin'

    v.cmd [=[
        hi! SignColumn guifg=#737aa2 guibg=NONE
        hi! CursorLineNr guibg=NONE
        hi! Folded guifg=#565f89 guibg=NONE
        hi! FoldColumn guibg=NONE

        hi! Type guifg=#2ac3de
        hi! cCustomClass guifg=#2ac3de
        hi! cppStructure guifg=#2ac3de
        hi! Ignore guifg=#444b6a

        hi! markdownLinkText guifg=#7aa2f7 gui=NONE
        hi! IndentBlanklineChar guifg=#3b4261 gui=nocombine

        hi! jsonCommentError guifg=#565f89
    ]=]

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

    if user.settings.line == 'airline' then
        v.cmd [=[
            function! Init_lua_tokyonight_airline_theme_patch(palette)
                if g:airline_theme != 'tokyonight'
                    return
                endif

                let airline_error = ['#000000', '#db4b4b', '0', '0']
                let airline_warning = ['#000000', '#e0af68', '0', '0']

                let a:palette.normal.airline_warning = airline_warning
                let a:palette.normal.airline_error = airline_error
                let a:palette.insert.airline_warning = airline_warning
                let a:palette.insert.airline_error = airline_error
                let a:palette.replace.airline_warning = airline_warning
                let a:palette.replace.airline_error = airline_error
                let a:palette.visual.airline_warning = airline_warning
                let a:palette.visual.airline_error = airline_error
                let a:palette.inactive.airline_warning = airline_warning
                let a:palette.inactive.airline_error = airline_error
                let a:palette.terminal.airline_warning = airline_warning
                let a:palette.terminal.airline_error = airline_error
            endfunction
        ]=]
        v.g.airline_theme_patch_func = 'Init_lua_tokyonight_airline_theme_patch'
    end

    if tokyonight_transparent then
        v.cmd 'hi! CursorLine ctermbg=242 guibg=#3b4261'
    end

    return true
end

m.config = function()
    return {
        style = "storm",
        light_style = "day",
        transparent = false,
        terminal_colors = true,
        styles = {
            comments = { italic = false },
            keywords = { italic = false },
            functions = {},
            variables = {},
            sidebars = "dark",
            floats = "dark",
        },
        sidebars = { "qf", "help" },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = false,
        --on_colors = function(colors) end,
        on_highlights = function(highlights, colors)
            highlights['@variable.builtin'] = { fg = colors.orange }
            highlights['FloatBorder'] = { fg = colors.fg, bg = colors.bg_dark }
        end
    }
end

return m
