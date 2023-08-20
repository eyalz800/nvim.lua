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
m.colorscheme = v.fn.system('if [ -e ~/.vim/.color ] ; then cat ~/.vim/.color ; else echo tokyonight; fi')
m.colorscheme_settings = { tokyonight={style='storm'} }
m.powerline = true
m.lsp = 'coc'
m.lsp_config = {
    coc = {
        tab_trigger = true,
        plugins = {
            'coc-clangd',
            'coc-pyright',
            'coc-vimlsp',
            'coc-lua',
            'coc-snippets',
            'coc-spell-checker' }
    }
}
m.install_options = { clang_version=16 }
m.finder = 'fzf-lua'
m.line = 'lualine'
m.file_explorer = 'nvim-tree'
m.file_explorer_config = {nvim_tree={window_picker=false}}
m.code_explorer = 'tagbar'

return m
