local m = {}
local v = require 'vim'
local user = require 'user'
local exec_detach = require 'lib.exec_detach'.exec_detach

m.configure = function()
    if v.o.background == 'light' then
        v.opt.background = 'dark'
        exec_detach('color tokyonight')
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
        hi SignColumn guifg=#737aa2 guibg=NONE
        hi CursorLineNr guibg=NONE
        hi Folded guifg=#565f89 guibg=NONE
        hi FoldColumn guibg=NONE

        hi Type guifg=#2ac3de
        hi cCustomClass guifg=#2ac3de
        hi cppStructure guifg=#2ac3de
        hi Ignore guifg=#444b6a

        hi markdownLinkText guifg=#7aa2f7 gui=NONE
        hi IndentBlanklineChar guifg=#3b4261 gui=nocombine

        hi jsonCommentError guifg=#565f89
    ]=]

    if user.settings.lsp == 'coc' then
        v.cmd [=[
            highlight clear CocUnusedHighlight
            highlight link CocUnusedHighlight DiagnosticUnderlineWarn
            highlight clear CocErrorFloat
            highlight link CocErrorFloat None
            highlight clear CocWarningFloat
            highlight link CocWarningFloat None
            highlight clear CocInfoFloat
            highlight link CocInfoFloat None
            highlight def link FgCocErrorFloatBgCocFloating None
            highlight def link FgCocWarningFloatBgCocFloating None
        ]=]
    end

    if user.settings.finder == 'fzf' then
        v.cmd [=[
            let g:fzf_colors =
            \ { 'fg':      ['fg', 'Normal'],
              \ 'bg':      ['bg', 'Normal'],
              \ 'hl':      ['fg', 'SpecialKey'],
              \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
              \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
              \ 'hl+':     ['fg', 'String'],
              \ 'info':    ['fg', 'Comment'],
              \ 'border':  ['fg', 'Ignore'],
              \ 'prompt':  ['fg', 'StorageClass'],
              \ 'pointer': ['fg', 'Error'],
              \ 'marker':  ['fg', 'Keyword'],
              \ 'spinner': ['fg', 'Label'],
              \ 'header':  ['fg', 'Comment'] }
        ]=]
    end

    if user.settings.status_line == 'airline' then
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
        v.cmd 'hi CursorLine ctermbg=242 guibg=#3b4261'
    end

    return true
end

return m
