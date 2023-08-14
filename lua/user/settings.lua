local m = {}

m.indentation = 4
m.expand_tabs = true
m.respect_editor_config = true
m.swap_files = false
m.osc_copy = true
m.gui_colors = true
m.root_paths = {'.git', '.repo', '.files'}
m.git_plugin = 'gitsigns'
m.enable_gutentags = false
m.colorscheme = 'tokyonight'
m.colorscheme_settings = { tokyonight={style='storm'} }
m.powerline = true
m.lsp = 'coc'
m.lsp_config = {coc_plugins={'coc-clangd',
                             'coc-pyright',
                             'coc-vimlsp',
                             'coc-lua',
                             'coc-snippets',
                             'coc-spell-checker'}}
m.finder = 'fzf'
m.status_line = 'airline'
m.file_explorer = 'nvim-tree'
m.code_explorer = 'tagbar'

return m
