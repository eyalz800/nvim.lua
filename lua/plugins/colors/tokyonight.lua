local m = {}
local user = require 'user'
local nvim_set_hl = vim.api.nvim_set_hl

m.name = 'tokyonight'

m.setup = function()
    require 'tokyonight'.setup(m.config())
end

m.config = function()
    local settings = user.settings.colorscheme_settings
    m.tokyonight_config = require 'tokyonight.config'

    return {
        style = (settings.tokyonight or {}).style or 'storm',
        light_style = 'day',
        transparent = settings.transparent or false,
        terminal_colors = true,
        styles = {
            comments = { italic = false },
            keywords = { italic = false },
            functions = {},
            variables = {},
            sidebars = 'dark',
            floats = 'dark',
        },
        sidebars = { 'qf', 'help', 'Outline' },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = false,
        on_highlights = function(highlights, color)
            highlights.CursorLineNr = { fg = color.fg_dark }
            highlights.FloatBorder = { fg = color.fg, bg = color.bg_dark }
            highlights.Folded = { fg = color.comment, bg = color.none }
            highlights.Ignore = { fg = vim.o.background == 'dark' and '#444b6a' or color.bg_dark}
            highlights.InitLuaDebugBP = { fg = color.orange }
            highlights.InitLuaDebugPC = { fg = color.green }
            highlights.FzfLuaBorder = { fg = color.fg_dark }
            highlights.FzfLuaTitle = { fg = color.fg, bg = color.bg }
            highlights.FzfLuaPreviewTitle = { fg = color.fg, bg = color.bg }
            highlights.FzfLuaTitleFlags = { fg = color.fg, bg = color.bg }
            highlights.NvimTreeWinSeparator = { link = 'WinSeparator' }
            highlights.InitLuaBufferLineVisibleFg = { fg = color.fg_dark }
            highlights.InitLuaBufferLineSelectedFg = { fg = color.fg }
            highlights.WinBarNC = { link = 'WinBar' }
            highlights.WinBar = { bg = color.bg }

            highlights['@variable.builtin'] = { fg = color.magenta }
            highlights['@keyword'] = { fg = color.blue1 }
            highlights['@lsp.typemod.type.defaultLibrary'] = { fg = color.blue1 }
            highlights['@type.builtin'] = { fg = color.blue1 }
            highlights['@string.escape'] = { fg = color.blue1 }
            highlights['@lsp.typemod.variable.defaultLibrary.cpp'] = { fg = color.orange }
            highlights['@lsp.typemod.enumMember.defaultLibrary.cpp'] = { fg = color.orange }
            highlights['@lsp.typemod.function.defaultLibrary.cpp'] = { fg = color.blue }
            highlights['@lsp.typemod.method.defaultLibrary.cpp'] = { fg = color.blue }
            highlights['@lsp.typemod.function.defaultLibrary.c'] = { fg = color.blue }
            highlights['@constructor.cpp'] = { fg = color.blue }
            highlights['@keyword.function'] = { fg = color.blue }
            highlights['@keyword.operator.c'] = { fg = color.blue5 }
            highlights['@constructor.lua'] = { fg = color.fg }
            highlights['@punctuation.bracet'] = { fg = color.fg }
            highlights['@punctuation.delimiter'] = { fg = color.fg }
            highlights['@operator'] = { fg = color.fg }
            highlights['@conditional.ternary'] = { fg = color.fg }

            if vim.env.TERM == 'xterm-kitty' then
                highlights.InitLuaBufferLineIndicator = { bg = color.red }
                if user.settings.bar == 'barbecue' or user.settings.bar == 'dropbar' then
                    highlights.InitLuaBufferLineNormalBg = { bg = color.bg_highlight }
                    highlights.InitLuaBufferLineVisibleBg = { bg = color.bg }
                    highlights.InitLuaBufferLineSelectedBg = { bg = color.bg }
                end
            end
        end
    }
end

m.pre_apply = function(colors_name)
    if colors_name == 'tokyonight-day' then
        vim.opt.background = 'light'
        vim.env.BAT_THEME = 'Monokai Extended Light'
    else
        vim.opt.background = 'dark'
        vim.env.BAT_THEME = 'Monokai Extended Origin'
    end
end

m.apply = function(colors_name)
    m.name = colors_name

    if user.settings.lsp == 'nvim' then
        nvim_set_hl(0, 'DiagnosticUnnecessary', { link = 'DiagnosticUnderlineWarn' })
    elseif user.settings.lsp == 'coc' then
        nvim_set_hl(0, 'CocUnusedHighlight', { link = 'DiagnosticUnderlineWarn'})
    end

    vim.cmd [=[
        hi! link CocUnusedHighlight DiagnosticUnderlineWarn
        hi! DiagnosticVirtualTextError guibg=NONE
        hi! DiagnosticVirtualTextWarn guibg=NONE
        hi! DiagnosticVirtualTextHint guibg=NONE
        hi! DiagnosticVirtualTextInfo guibg=NONE
    ]=]

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

    if user.settings.line == 'airline' then
        vim.cmd [=[
            function! Init_lua_tokyonight_airline_theme_patch(palette)
                if g:airline_theme != 'tokyonight'
                    return
                endif

                if &background == 'dark'
                    let airline_error = ['#000000', '#db4b4b', '0', '0']
                    let airline_warning = ['#000000', '#e0af68', '0', '0']
                else
                    let airline_error = ['#ffffff', '#db4b4b', '0', '0']
                    let airline_warning = ['#ffffff', '#e0af68', '0', '0']
                endif

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
        vim.g.airline_theme_patch_func = 'Init_lua_tokyonight_airline_theme_patch'
    end
end

return m
