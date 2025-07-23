local m = {}
local v = require 'vim'

m.indentation = 4
m.expand_tabs = true
m.respect_editor_config = true
m.swap_files = false
m.osc_copy = true
m.gui_colors = true
m.root_paths = {'.git', '.repo', '.files'}
m.git_plugin = 'gitsigns'
m.enable_gutentags = false
m.colorscheme = v.fn.system('if [ -e ~/.tmux.color ] ; then cat ~/.tmux.color ; else echo tokyonight; fi')
m.colorscheme_settings = { tokyonight={style='storm'} }
m.powerline = true
m.install_options = { clang_version = 19 }
m.finder = 'fzf-lua'
m.line = 'lualine'
m.buffer_line = 'bufferline'
m.bar = 'barbecue'
m.file_explorer = 'nvim-tree'
m.file_explorer_config = { nvim_tree = { window_picker = false } }
m.code_explorer = 'symbols-outline'
m.code_explorer_config = { auto_open_min_columns = 180 }
m.edge = nil
m.pin_bars = 'pin'
m.treesitter = true
m.treesitter_auto_install = true
m.terminal = 'toggleterm'
m.float_term = 'lazyterm'
m.external_terminal_opts = { set_background = true }
m.quickfix_expand = true
m.column = 'statuscol'
m.debugger = 'dap'
m.launch_json = { 'launch.json', '.vscode/launch.json' }
m.pairs = 'nvim-autopairs'
m.jumper = 'flash'
m.format_on_pairs = true
m.line_number = {
    number = true,
    relative = true,
    together = true,
}
m.colorizer = 'nvim-colorizer'
m.zoom = 'zoomwintab'
m.cscope_dynamic = false
m.copilot = false
m.codecompanion = false
m.avante = false
m.minuet_ai = false
m.minuet_config = {
    provider = 'openai',
    provider_options = nil,
}
m.lsp = 'nvim'
m.lsp_config = {
    nvim = {
        virtual_text = true,
        diagnostic_hover = true,
        completion_border = true,
        snippets = true,
        servers = {
            cpp = {
                name = 'clangd',
                settings = {
                    cmd = {
                        'clangd',
                        '--fallback-style=microsoft',
                    },
                }
            },
            lua = {
                name = 'lua_ls',
                settings = {
                    Lua = {
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                    },
                }
            },
            python = 'pyright',
            rust = 'rust_analyzer',
        },
    },
    coc = {
        tab_trigger = true,
        plugins = {
            'coc-clangd',
            'coc-pyright',
            'coc-vimlsp',
            'coc-lua',
            'coc-snippets',
            'coc-spell-checker' }
    },
}

return m
