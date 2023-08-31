local m = {}
local user = require 'user'

m.config = function()
    local options = {
        options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            disabled_filetypes = {
                statusline = {},
                winbar = {
                    'NvimTree', 'nerdtree',
                    'VimspectorPrompt', 'vimspector-disassembly',
                    'dap-repl', 'dapui_console', 'dapui_scopes',
                    'dapui_breakpoints', 'dapui_stacks', 'dapui_watches'
                },
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = true,
            refresh = {
                statusline = 200,
                tabline = 200,
                winbar = 200,
            }
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { { 'filename', path = 1 } },
            lualine_x = { 'encoding', 'fileformat', 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = { 'location' }
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {},
        winbar = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { { 'filename', path = 1 } },
            lualine_x = {},
            lualine_y = {},
            lualine_z = {}
        },
        inactive_winbar = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { { 'filename', path = 1 } },
            lualine_x = {},
            lualine_y = {},
            lualine_z = {}
        },
        extensions = {}
    }

    if user.settings.bar ~= 'lualine' then
        options.winbar = nil
        options.inactive_winbar = nil
    end

    return options
end

return m
