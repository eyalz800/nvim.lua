local m = {}
local v = require 'vim'
local user = require 'user'

---@diagnostic disable: different-requires

m.start = function()
    require 'lazy'.setup(m.plugins)
end

m.on_update = function()
    local lazy_locks = v.fn.stdpath('config') .. '/lazy-locks'
    local lazy_lock = v.fn.stdpath('config') .. '/lazy-lock.json'
    local snapshot = lazy_locks .. os.date('/%Y-%m-%dT%H:%M:%S.json')
    if not v.loop.fs_stat(lazy_lock) then
        return
    end
    v.fn.mkdir(lazy_locks, 'p')
    v.loop.fs_copyfile(lazy_lock, snapshot)
end

m.plugins = {
    {
        'eyalz800/tokyonight.nvim',
        priority = 1000,
        config = function()
            local tokyonight_color = require 'plugins.colors.tokyonight'
            require 'tokyonight'.setup(tokyonight_color.config())
        end,
    },
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            local options = require 'plugins.config.gitsigns'.options
            require 'gitsigns'.setup(options)
        end,
        cond = user.settings.git_plugin == 'gitsigns'
    },
    {
        'airblade/vim-gitgutter',
        cond = user.settings.git_plugin == 'gitgutter',
    },
    'puremourning/vimspector',
    'tpope/vim-fugitive',
    {
        'vim-airline/vim-airline',
        cond = user.settings.line == 'airline'
    },
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            local options = require 'plugins.config.lualine'.options
            require 'lualine'.setup(options)
        end,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cond = user.settings.line == 'lualine'
    },
    {
        'nvim-tree/nvim-tree.lua',
        config = function()
            local options = require 'plugins.config.nvim-tree'.options
            require 'nvim-tree'.setup(options)
        end,
        cond = user.settings.file_explorer == 'nvim-tree',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
    },
    {
        'preservim/nerdtree',
        dependencies = {
            'ryanoasis/vim-devicons',
            'tiagofumo/vim-nerdtree-syntax-highlight',
            'Xuyuanp/nerdtree-git-plugin'
        },
        cond = user.settings.file_explorer == 'nerdtree',
    },
    {
        'akinsho/bufferline.nvim',
        event = 'UIEnter',
        config = function()
            local bufferline_conf = require 'plugins.config.bufferline'
            require "bufferline".setup(bufferline_conf.config())
        end,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cond = user.settings.buffer_line == 'bufferline',
    },
    {
        'majutsushi/tagbar',
        cond = user.settings.code_explorer == 'tagbar',
    },
    {
        'simrat39/symbols-outline.nvim',
        config = function()
            local options = require 'plugins.config.symbols-outline'.options
            require 'symbols-outline'.setup(options)
        end,
        cond = user.settings.code_explorer == 'symbols-outline',
    },
    {
        'ludovicchabant/vim-gutentags',
        cond= user.settings.enable_gutentags == true,
    },
    {
        "junegunn/fzf",
        dir="~/.fzf",
        build="./install --all",
    },
    {
        'junegunn/fzf.vim',
        -- This is needed due to source index and coc-fzf still using vim fzf apis.
        -- cond = user.settings.finder == 'fzf',
    },
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local fzf_lua_conf = require 'plugins.config.fzf-lua'
            require 'fzf-lua'.setup(fzf_lua_conf.config())
        end,
        cond = user.settings.finder == 'fzf-lua',
    },
    { 'neoclide/coc.nvim',
        branch = 'release',
        cond = user.settings.lsp == 'coc'
    },
    {
        'antoinemadec/coc-fzf',
        branch='release',
        cond = user.settings.lsp == 'coc'
    },
    'skywind3000/asyncrun.vim',
    'justinmk/vim-sneak',
    'easymotion/vim-easymotion',
    'mg979/vim-visual-multi',
    { 'erig0/cscope_dynamic', build=require('lib.os_bin').sed .. " -i 's/call s:runShellCommand/call system/g' ./plugin/cscope_dynamic.vim" },
    'octol/vim-cpp-enhanced-highlight',
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

return m
