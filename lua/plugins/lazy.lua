local m = {}
local user = require 'user'

local plugins = {
    {
        'eyalz800/tokyonight.nvim',
        lazy = false,
        priority = 1000,
    },
    {
        'lewis6991/gitsigns.nvim',
        opts = require 'plugins.config.gitsigns'.options,
        cond = user.settings.git_plugin == 'gitsigns'
    },
    {
        'airblade/vim-gitgutter',
        cond = user.settings.git_plugin == 'gitgutter',
    },
    'puremourning/vimspector',
    'tpope/vim-fugitive',
    'vim-airline/vim-airline',
    {
        'nvim-tree/nvim-tree.lua',
        cond = user.settings.file_explorer == 'nvim-tree',
        opts = require 'plugins.config.nvim-tree'.options,
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
    },
    {
        'preservim/nerdtree',
        cond = user.settings.file_explorer == 'nerdtree',
        dependencies = {
            'ryanoasis/vim-devicons',
            'tiagofumo/vim-nerdtree-syntax-highlight',
            'Xuyuanp/nerdtree-git-plugin'
        },
    },
    {
        'majutsushi/tagbar',
        cond = user.settings.code_explorer == 'tagbar',
    },
    {
        'simrat39/symbols-outline.nvim',
        opts = require 'plugins.config.symbols-outline'.options,
        cond = user.settings.code_explorer == 'symbols-outline',
    },
    {
        'ludovicchabant/vim-gutentags',
        cond=user.settings.enable_gutentags == true,
    },
    {
        "junegunn/fzf",
        dir="~/.fzf",
        build="./install --all",
        cond = user.settings.finder == 'fzf',
    },
    {
        'junegunn/fzf.vim',
        cond = user.settings.finder == 'fzf',
    },
    'skywind3000/asyncrun.vim',
    'justinmk/vim-sneak',
    'easymotion/vim-easymotion',
    'mg979/vim-visual-multi',
    { 'erig0/cscope_dynamic', build=require('lib.os_bin').sed .. " -i 's/call s:runShellCommand/call system/g' ./plugin/cscope_dynamic.vim" },
    'octol/vim-cpp-enhanced-highlight',
    { 'neoclide/coc.nvim', branch='release', cond=(user.settings.lsp == 'coc') },
    { 'antoinemadec/coc-fzf', branch='release', cond=(user.settings.lsp == 'coc') },
    'tmsvg/pear-tree',
    'mbbill/undotree',
    'tpope/vim-commentary',
    'tomasiser/vim-code-dark',
    'ntpeters/vim-better-whitespace',
    'troydm/zoomwintab.vim',
    'jreybert/vimagit',
    'tpope/vim-obsession',
    'haya14busa/incsearch.vim',
    'haya14busa/incsearch-fuzzy.vim',
    { 'rrethy/vim-hexokinase', build='make hexokinase' },
    'christoomey/vim-tmux-navigator',
    'tpope/vim-surround',
    'j5shi/CommandlineComplete.vim',
    'kshenoy/vim-signature',
    'vim-python/python-syntax',
    'scrooloose/vim-slumlord',
    'aklt/plantuml-syntax',
    'skywind3000/asynctasks.vim',
    'yaronkh/vim-winmanip',
    'rbgrouleff/bclose.vim',
    'lukas-reineke/indent-blankline.nvim',
    'metakirby5/codi.vim',
    'tpope/vim-abolish',
    'wellle/targets.vim',
    'eyalz800/vim-ultisnips',
    'voldikss/vim-floaterm',
    'will133/vim-dirdiff',
    'junegunn/goyo.vim',
    'yazgoo/yank-history',
    'qpkorr/vim-bufkill',
    'cormacrelf/vim-colors-github',
}

require('lazy').setup(plugins)

return m
