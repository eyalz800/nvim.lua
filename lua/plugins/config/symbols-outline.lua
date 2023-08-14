local m = {}
local cmd = require 'vim.cmd'.silent

m.open_status = false

m.open = function()
    cmd 'SymbolsOutlineOpen'
    m.open_status = true
end

m.close = function()
    cmd 'SymbolsOutlineClose'
    m.open_status = false
end

m.is_open = function()
    return m.open_status
end

m.toggle = function()
    cmd 'SymbolsOutlineToggle'
    if m.open_status then
        m.open_status = false
    else
        m.open_status = true
    end
end

m.options = {
    highlight_hovered_item = true,
    show_guides = true,
    auto_preview = false,
    position = 'right',
    relative_width = true,
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
    keymaps = { -- These keymaps can be a string or a table for multiple keys
        close = { "<Esc>", "q" },
        goto_location = "<Cr>",
        focus_location = "o",
        hover_symbol = "<C-space>",
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

return m

