local m = {}
local barbecue = nil
local user = require 'user'

m.setup = function()
    require 'barbecue'.setup(m.config())

    if user.settings.lsp == 'nvim' then
        vim.api.nvim_create_autocmd({ 'winresized', 'bufwinenter', 'cursorhold', 'insertleave' }, {
            group = vim.api.nvim_create_augroup('init.lua.barbecue.updater', {}),
            callback = require 'plugins.config.barbecue'.on_update
        })
    end

    vim.api.nvim_create_autocmd('filetype', {
        pattern = 'fugitiveblame',
        group = vim.api.nvim_create_augroup('init.lua.fugitive-barbecue', {}),
        callback = function()
            vim.wo.winbar = '  Blame'
        end
    })

    if user.settings.codecompanion then
        vim.api.nvim_create_autocmd('User', {
            pattern = 'CodeCompanionDiffAttached',
            group = vim.api.nvim_create_augroup('init.lua.codecompanion-barbecue', {}),
            callback = function(data)
                local winid = vim.fn.win_getid(data.winnr)
                vim.wo[winid].winbar = ' Code Companion '
            end
        })
    end
end

m.on_update = function()
    if not barbecue then
        return
    end
    local success, ui = pcall(require, 'barbecue.ui')
    if success then
        m.on_update = ui.update
        m.on_update()
    end
end

m.config = function()
    barbecue = require 'barbecue'

    return {
        ---Whether to attach navic to language servers automatically.
        ---
        ---@type boolean
        attach_navic = false,

        ---Whether to create winbar updater vim.api.nvim_create_autocmd.
        ---
        ---@type boolean
        create_autocmd = false,

        ---Buftypes to enable winbar in.
        ---
        ---@type string[]
        include_buftypes = { "" },

        ---Filetypes not to enable winbar in.
        ---
        ---@type string[]
        exclude_filetypes = { "netrw", "toggleterm" },

        modifiers = {
            ---Filename modifiers applied to dirname.
            ---
            ---See: `:help filename-modifiers`
            ---
            ---@type string
            dirname = ":~:.",

            ---Filename modifiers applied to basename.
            ---
            ---See: `:help filename-modifiers`
            ---
            ---@type string
            basename = "",
        },

        ---Whether to display path to file.
        ---
        ---@type boolean
        show_dirname = true,

        ---Whether to display file name.
        ---
        ---@type boolean
        show_basename = true,

        ---Whether to replace file icon with the modified symbol when buffer is
        ---modified.
        ---
        ---@type boolean
        show_modified = false,

        ---Get modified status of file.
        ---
        ---NOTE: This can be used to get file modified status from SCM (e.g. git)
        ---
        ---@type fun(bufnr: number): boolean
        modified = function(bufnr) return vim.bo[bufnr].modified end,

        ---Whether to show/use navic in the winbar.
        ---
        ---@type boolean
        show_navic = true,

        ---Get leading custom section contents.
        ---
        ---NOTE: This function shouldn't do any expensive actions as it is run on each
        ---render.
        ---
        ---@type fun(bufnr: number, winnr: number): barbecue.Config.custom_section
        lead_custom_section = function() return " " end,

        ---@alias barbecue.Config.custom_section
        ---|string # Literal string.
        ---|{ [1]: string, [2]: string? }[] # List-like table of `[text, highlight?]` tuples in which `highlight` is optional.
        ---
        ---Get custom section contents.
        ---
        ---NOTE: This function shouldn't do any expensive actions as it is run on each
        ---render.
        ---
        ---@type fun(bufnr: number, winnr: number): barbecue.Config.custom_section
        custom_section = function() return " " end,

        ---@alias barbecue.Config.theme
        ---|'"auto"' # Use your current colorscheme's theme or generate a theme based on it.
        ---|string # Theme located under `barbecue.theme` module.
        ---|barbecue.Theme # Same as '"auto"' but override it with the given table.
        ---
        ---Theme to be used for generating highlight groups dynamically.
        ---
        ---@type barbecue.Config.theme
        theme = "auto",

        ---Whether context text should follow its icon's color.
        ---
        ---@type boolean
        context_follow_icon_color = false,

        symbols = {
            ---Modification indicator.
            ---
            ---@type string
            modified = "●",

            ---Truncation indicator.
            ---
            ---@type string
            ellipsis = "…",

            ---Entry separator.
            ---
            ---@type string
            separator = "",
        },

        ---@alias barbecue.Config.kinds
        ---|false # Disable kind icons.
        ---|table<string, string> # Type to icon mapping.
        ---
        ---Icons for different context entry kinds.
        ---
        ---@type barbecue.Config.kinds
        kinds = {
            File = "",
            Module = "",
            Namespace = "",
            Package = "",
            Class = "",
            Method = "",
            Property = "",
            Field = "",
            Constructor = "",
            Enum = "",
            Interface = "",
            Function = "",
            Variable = "",
            Constant = "",
            String = "",
            Number = "",
            Boolean = "",
            Array = "",
            Object = "",
            Key = "",
            Null = "",
            EnumMember = "",
            Struct = "",
            Event = "",
            Operator = "",
            TypeParameter = "",
        },
    }
end

return m
