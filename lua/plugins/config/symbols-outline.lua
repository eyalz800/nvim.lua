local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent
local symbols_outline = nil

m.open = function(options)
    options = options or { focus = true }
    if not m.is_open() and options.focus ~= 'always' then
        options.focus = false
    end
    symbols_outline.open_outline()
    if v.bo.filetype == 'Outline' then
        if not options.focus then
            cmd 'wincmd p'
        end

        v.api.nvim_set_option_value('signcolumn', 'no',
            { scope = 'local', win = symbols_outline.view.winnr })
    elseif options.focus and symbols_outline.view.winnr then
        v.fn.win_gotoid(symbols_outline.view.winnr)
    end
end

m.close = function()
    if m.is_open() then
        symbols_outline.close_outline()
    end
end

m.is_open = function()
    return symbols_outline.view:is_open()
end

m.toggle = function()
    if m.is_open() then
        symbols_outline.toggle_outline()
    end
end

m.config = function()
    symbols_outline = require 'symbols-outline'
    return {
        highlight_hovered_item = true,
        show_guides = true,
        auto_preview = false,
        position = 'right',
        relative_width = false,
        width = 30,
        auto_close = false,
        show_numbers = false,
        show_relative_numbers = false,
        show_symbol_details = true,
        preview_bg_highlight = 'Pmenu',
        autofold_depth = nil,
        auto_unfold_hover = true,
        fold_markers = { '', '' },
        wrap = false,
        keymaps = {
            close = { "q" },
            goto_location = "<cr>",
            focus_location = "o",
            hover_symbol = "<c-space>",
            toggle_preview = "K",
            rename_symbol = "r",
            code_actions = "a",
            fold = "h",
            unfold = "l",
            fold_all = "W",
            unfold_all = "E",
            fold_reset = "R",
        },
        lsp_blacklist = {},
        symbol_blacklist = {},
        symbols = {
            File = { icon = "󰈙", hl = "@text.uri" },
            Module = { icon = "󰆧", hl = "@namespace" },
            Namespace = { icon = "󰅩", hl = "@namespace" },
            Package = { icon = "󰏗", hl = "@namespace" },
            Class = { icon = "", hl = "@type" },
            Method = { icon = "󰊕", hl = "@method" },
            Property = { icon = "", hl = "@method" },
            Field = { icon = "", hl = "@field" },
            Constructor = { icon = "", hl = "@constructor" },
            Enum = { icon = "", hl = "@type" },
            Interface = { icon = "", hl = "@type" },
            Function = { icon = "󰊕", hl = "@function" },
            Variable = { icon = "", hl = "@constant" },
            Constant = { icon = "", hl = "@constant" },
            String = { icon = "", hl = "@string" },
            Number = { icon = "", hl = "@number" },
            Boolean = { icon = "", hl = "@boolean" },
            Array = { icon = "󰅪", hl = "@constant" },
            Object = { icon = "", hl = "@type" },
            Key = { icon = "󰌆", hl = "@type" },
            Null = { icon = "󰟢", hl = "@type" },
            EnumMember = { icon = "", hl = "@field" },
            Struct = { icon = "", hl = "@type" },
            Event = { icon = "󱐋", hl = "@type" },
            Operator = { icon = "", hl = "@operator" },
            TypeParameter = { icon = "󰠱", hl = "@parameter" },
            Component = { icon = "󰅴", hl = "@function" },
            Fragment = { icon = "󰅴", hl = "@constant" },
        },
    }
end

return m
