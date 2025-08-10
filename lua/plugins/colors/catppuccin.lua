local m = {}
local user = require 'user'
local nvim_set_hl = vim.api.nvim_set_hl

m.name = 'catppuccin'

m.setup = function()
    m.settings = user.settings.colorscheme_settings
    m.catppuccin = require 'catppuccin'
    m.catppuccin.setup(m.config())
end

m.config = function()
    return {
        flavour = 'mocha',
        background = {
            light = 'latte',
            dark = 'mocha',
        },
        transparent_background = m.settings.transparent, -- disables setting the background color.
        show_end_of_buffer = false,
        term_colors = true,
        dim_inactive = {
            enabled = false,
            shade = 'dark',
            percentage = 0.15,
        },
        no_italic = true,
        no_bold = true,
        no_underline = false,
        styles = {
            comments = {},
            conditionals = {},
            loops = {},
            functions = {},
            keywords = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {},
        },
        color_overrides = {},
        integrations = {
            cmp = true,
            gitsigns = true,
            nvimtree = true,
            treesitter = true,
            notify = false,
            mini = false,
        },
        highlight_overrides = {
            all = function(color)
                local options =  {
                    Ignore = { fg = color.subtext1 },
                    BufferLineFill = { fg = color.mantle },
                    BufferLineOffsetSeparator = { fg = color.mantle, bg = color.mantle },
                    --NvimTreeWinSeparator = { fg = color.mantle, bg = color.mantle },
                    InitLuaBufferLineSelectedBg = { bg = color.mantle },
                    InitLuaBufferLineVisibleBg = { bg = color.mantle },
                    WinBarNC = { link = 'WinBar' },
                }

                if user.settings.bar == 'barbecue' or user.settings.bar == 'dropbar' then
                    options.BufferLineFill = nil
                    options.InitLuaBufferLineBg = { fg = color.mantle, bg = color.mantle }
                    options.InitLuaBufferLineSelectedBg = { bg = color.base }
                    options.InitLuaBufferLineVisibleBg = { bg = color.base }
                    options.InitLuaBufferLineVisibleBg = { bg = color.base }
                end

                if vim.env.TERM == 'xterm-kitty' then
                    options.InitLuaBufferLineIndicator = { bg = color.red }
                end

                return options
            end,
            latte = function(color)
                local options = {}

                if user.settings.bar == 'barbecue' then
                    options.InitLuaBufferLineNormalBg = { bg = color.crust }
                end

                return options
            end,
        }
    }
end

m.pre_apply = function(colors_name)
    if colors_name == 'catppuccin-latte' then
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
            ['fg+'] = { 'fg', 'SpecialKey' },
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
