local m = {}
m.indentation = 4
m.guess_indent = true
m.expand_tabs = true
m.respect_editor_config = true
m.swap_files = false
m.osc_copy = true
m.gui_colors = true
m.root_paths = {'.git', '.repo', '.files'}
m.git_plugin = 'gitsigns'
m.enable_gutentags = false
m.colorscheme = vim.fn.system('if [ -e ~/.tmux.color ] ; then cat ~/.tmux.color ; else echo tokyonight; fi')
m.colorscheme_settings = { tokyonight={style='storm'} }
m.powerline = true
m.install_options = { clang_version = 20 }
m.finder = 'fzf-lua'
m.line = 'lualine'
m.buffer_line = 'bufferline'
m.bar = 'barbecue'
m.file_explorer = 'nvim-tree'
m.file_explorer_config = { nvim_tree = { window_picker = false } }
m.code_explorer = 'symbols-outline'
m.code_explorer_config = {
    auto_open_min_columns = 180,
    winhl = 'edge-window'
}
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
m.comment = 'comment.nvim'
m.noice = true
m.fidget = true
m.diff = 'mini'
m.copilot = true
m.codecompanion = true
m.codecompanion_config = {
    progress = m.fidget and 'fidget' or 'noice',
    -- strategies = {
    --     chat = {
    --         adapter = 'gemini'
    --     },
    --     inline = {
    --         adapter = 'gemini'
    --     },
    -- },
}
m.minuet_ai = false
m.minuet_config = {
    --provider = 'openai',
    --provider = 'gemini',
    provider_options = nil,
}
m.quickfix_config = {
    winhl = 'edge-window'
}
m.signcolumn_config = {
    git_prefix = '',
    dbg_prefix = ' ',
    lsp_prefix = ' ',
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
                cmd = {
                    'clangd',
                    '--fallback-style=microsoft',
                },
                settings = {
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
            python = {
                name = 'pylsp',
                settings = {
                    pylsp = {
                        plugins = {
                            pycodestyle = {
                                ignore = {
                                    'E501', -- line too long
                                    'E302', -- expected 2 blank lines, found 1
                                    'E305', -- expected 2 blank lines after class or function definition, found 1
                                    'E261', -- at least two blank lines required before a class or function
                                    'E114', -- indentation is not a multiple of four
                                }
                            },
                            pyflakes = { enabled = false },
                        },
                    },
                },
            },
            pyright = 'pyright',
            rust = 'rust_analyzer',
            ts = 'ts_ls',
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
m.mason_lspconfig_autoenable = 'if-not-defined'

return m
