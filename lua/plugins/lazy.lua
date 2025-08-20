local m = {}
local user = require 'user'

---@diagnostic disable: different-requires

m.icons_plugin = {
    ['nvim-web-devicons'] = 'nvim-tree/nvim-web-devicons',
    ['mini'] = 'echasnovski/mini.icons',
}


m.setup = function()
    local lazy_conf = require 'plugins.config.lazy'

    require 'lazy'.setup(m.plugins, lazy_conf.config())

    vim.api.nvim_create_autocmd('user', {
        pattern = 'LazyUpdatePre',
        group = vim.api.nvim_create_augroup('init.lua.lazy-update-pre', {}),
        callback = m.on_update
    })
end

m.on_update = function()
    local lazy_locks = vim.fn.stdpath('config') .. '/lazy-locks'
    local lazy_lock = vim.fn.stdpath('config') .. '/lazy-lock.json'
    local snapshot = lazy_locks .. os.date('/%Y-%m-%dT%H:%M:%S.json')
    if not vim.loop.fs_stat(lazy_lock) then
        return
    end
    vim.fn.mkdir(lazy_locks, 'p')
    vim.loop.fs_copyfile(lazy_lock, snapshot)
end

m.plugins = {
    -- Install FZF
    {
        'junegunn/fzf',
        name = 'fzf',
        dir = '~/.fzf',
        build = './install --all',
    },

    -- Neovim Plugins
    {
        'folke/which-key.nvim',
        config = function()
            require 'plugins.config.which-key'.setup()
        end,
    },
    {
        'folke/tokyonight.nvim',
        priority = 1000,
        config = function()
            require 'plugins.colors.tokyonight'.setup()
        end,
    },
    {
        'Mofiqul/vscode.nvim',
        priority = 1000,
        config = function()
            require 'plugins.colors.vscode'.setup()
        end,
    },
    {
        'catppuccin/nvim',
        priority = 1000,
        name = 'catppuccin',
        config = function()
            require 'plugins.colors.catppuccin'.setup()
        end,
    },
    {
        'williamboman/mason.nvim',
        config = function()
            require 'plugins.config.mason'.setup()
        end,
        cond = user.settings.lsp == 'nvim' or user.settings.debugger == 'dap'
    },
    {
        'nvim-lua/plenary.nvim',
    },
    {
        'j-hui/fidget.nvim',
        config = function()
            require 'plugins.config.fidget'.setup()
        end,
        cond = user.settings.fidget and user.settings.lsp == 'nvim',
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'https://codeberg.org/FelipeLema/cmp-async-path.git',
            'hrsh7th/cmp-buffer',
            {
                'eyalz800/friendly-snippets',
                cond = user.settings.lsp_config.nvim.snippets,
            },
        },
        cond = user.settings.lsp == 'nvim',
    },
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        config = function()
            require 'plugins.config.lazydev'.setup()
        end,
        cond = user.settings.lsp == 'nvim',
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            'williamboman/mason.nvim',
            'neovim/nvim-lspconfig',
        },
        config = function()
            require 'plugins.config.nvim-lsp'.setup()
        end,
        cond = user.settings.lsp == 'nvim',
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'j-hui/fidget.nvim',
            'hrsh7th/nvim-cmp',
            'folke/lazydev.nvim',
        },
        cond = user.settings.lsp == 'nvim',
    },
    {
        'luukvbaal/statuscol.nvim',
        config = function()
            require 'plugins.config.statuscol'.setup()
        end,
        cond = user.settings.column == 'statuscol',
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require 'plugins.config.nvim-treesitter'.setup()
        end,
        cond = user.settings.treesitter,
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        config = function()
            require 'plugins.config.nvim-treesitter-textobjects'.setup()
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
        cond = user.settings.treesitter,
    },
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require 'plugins.config.gitsigns'.setup()
        end,
        cond = user.settings.git_plugin == 'gitsigns'
    },
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require 'plugins.config.lualine'.setup()
        end,
        dependencies = {
            m.icons_plugin[user.settings.icons],
        },
        cond = user.settings.line == 'lualine'
    },
    {
        'utilyre/barbecue.nvim',
        name = 'barbecue',
        event = 'UIEnter',
        version = '*',
        config = function()
            require 'plugins.config.barbecue'.setup()
        end,
        dependencies = {
            'SmiteshP/nvim-navic',
            m.icons_plugin[user.settings.icons],
        },
        cond = user.settings.bar == 'barbecue' and user.settings.lsp == 'nvim',
    },
    {
        'Bekaboo/dropbar.nvim',
        event = 'UIEnter',
        config = function()
            require 'plugins.config.dropbar'.setup()
        end,
        cond = user.settings.bar == 'dropbar' and user.settings.lsp == 'nvim',
    },
    {
        'nvim-tree/nvim-tree.lua',
        config = function()
            require 'plugins.config.nvim-tree'.setup()
        end,
        dependencies = {
            m.icons_plugin[user.settings.icons],
        },
        cond = user.settings.file_explorer == 'nvim-tree' or user.settings.nvim_tree,
    },
    {
        'akinsho/bufferline.nvim',
        event = 'UIEnter',
        config = function()
            require 'plugins.config.bufferline'.setup()
        end,
        dependencies = {
            m.icons_plugin[user.settings.icons],
        },
        cond = user.settings.buffer_line == 'bufferline',
    },
    {
        'folke/edgy.nvim',
        event = 'VeryLazy',
        config = function()
            require 'plugins.config.edgy'.setup()
        end,
        dependencies = {
            'nvim-tree/nvim-tree.lua',
            'eyalz800/symbols-outline.nvim',
        },
        cond = user.settings.edge == 'edgy',
    },
    {
        'stevearc/stickybuf.nvim',
        config = function()
            require 'plugins.config.stickybuf'.setup()
        end,
        cond = user.settings.pin_bars == 'stickybuf',
    },
    {
        --'simrat39/symbols-outline.nvim',
        'eyalz800/symbols-outline.nvim',
        branch = 'main',
        config = function()
            require 'plugins.config.symbols-outline'.setup()
        end,
        cond = user.settings.code_explorer == 'symbols-outline',
    },
    {
        'ibhagwan/fzf-lua',
        dependencies = {
            m.icons_plugin[user.settings.icons],
            'junegunn/fzf',
        },
        config = function()
            require 'plugins.config.fzf-lua'.setup()
        end,
        cond = user.settings.finder == 'fzf-lua',
    },
    {
        'akinsho/toggleterm.nvim',
        version = '*',
        config = function()
            require 'plugins.config.toggleterm'.setup()
        end,
        cond = user.settings.terminal == 'toggleterm',
    },
    {
        'windwp/nvim-autopairs',
        event = { 'InsertEnter', 'VeryLazy' },
        config = function()
            require 'plugins.config.nvim-autopairs'.setup()
        end,
        dependencies = {
            'hrsh7th/nvim-cmp',
        },
        cond = user.settings.pairs == 'nvim-autopairs',
    },
    {
        'numToStr/Comment.nvim',
        event = 'VeryLazy',
        config = function()
            require 'plugins.config.comment-nvim'.setup()
        end,
        cond = user.settings.comment == 'comment.nvim',
    },
    {
        'nyngwang/NeoZoom.lua',
        event = 'VeryLazy',
        config = function()
            require 'plugins.config.neo-zoom'.setup()
        end,
        cond = user.settings.zoom == 'neo-zoom',
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require 'plugins.config.indent-blankline'.setup()
        end,
        cond = user.settings.indent_guides == 'indent-blankline',
    },
    {
        'NvChad/nvim-colorizer.lua',
        config = function()
            require 'plugins.config.colorizer'.setup()
        end,
        cond = user.settings.colorizer == 'nvim-colorizer',
    },
    {
        'jay-babu/mason-nvim-dap.nvim',
        event = 'VeryLazy',
        config = function()
            require 'plugins.config.mason-nvim-dap'.setup()
        end,
        dependencies = {
            'williamboman/mason.nvim',
            'rcarriga/nvim-dap-ui',
        },
        cond = user.settings.debugger == 'dap',
    },
    {
        'mfussenegger/nvim-dap',
        event = 'VeryLazy',
        config = function()
            require 'plugins.config.dap'.setup()
        end,
        cond = user.settings.debugger == 'dap',
    },
    {
        'rcarriga/nvim-dap-ui',
        event = 'VeryLazy',
        config = function()
            require 'plugins.config.dap-ui'.setup()
        end,
        dependencies = {
            'mfussenegger/nvim-dap',
            'edgy.nvim',
            'nvim-neotest/nvim-nio',
        },
        cond = user.settings.debugger == 'dap',
    },
    {
        'folke/flash.nvim',
        event = 'VeryLazy',
        config = function()
            require 'plugins.config.flash'.setup()
        end,
        keys = function()
            return require 'plugins.config.flash'.keys
        end,
        cond = user.settings.jumper == 'flash',
    },
    {
        'sindrets/diffview.nvim',
        event = 'VeryLazy',
        config = function()
            require 'plugins.config.diffview'.setup()
        end,
    },
    {
        'rmagatti/goto-preview',
        event = 'VeryLazy',
        config = function()
            require 'plugins.config.goto-preview'.setup()
        end,
        cond = user.settings.lsp == 'nvim',
    },
    {
        'https://gitlab.com/itaranto/plantuml.nvim',
        version = '*',
        event = 'VeryLazy',
        config = function()
            require 'plugins.config.plantuml'.setup()
        end,
    },
    {
        'zbirenbaum/copilot.lua',
        enabled = true,
        dependencies = {
            'hrsh7th/nvim-cmp',
        },
        cmd = 'Copilot',
        event = 'InsertEnter',
        config = function()
            require 'plugins.config.copilot'.setup()
        end,
        cond = user.settings.copilot,
    },
    {
        'olimorris/codecompanion.nvim',
        cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionActions', 'CodeCompanionCmd' },
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
            'j-hui/fidget.nvim',
        },
        config = function()
            require 'plugins.config.codecompanion'.setup()
        end,
        cond = user.settings.codecompanion,
    },
    {
        'milanglacier/minuet-ai.nvim',
        config = function()
            require 'plugins.config.minuet-ai'.setup()
        end,
        cond = user.settings.minuet_ai,
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        ft = { 'markdown', 'codecompanion' },
        event = 'VeryLazy',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            m.icons_plugin[user.settings.icons],
        },
        config = function()
            require 'plugins.config.render-markdown'.setup()
        end,
    },
    {
        'rcarriga/nvim-notify',
        config = function()
            require 'plugins.config.nvim-notify'.setup()
        end,
        cond = user.settings.noice and user.settings.notifier == 'noice',
    },
    {
        'folke/noice.nvim',
        config = function()
            require 'plugins.config.noice'.setup()
        end,
        dependencies = {
            'MunifTanjim/nui.nvim',
            'rcarriga/nvim-notify',
        },
        cond = user.settings.noice,
    },
    {
        'echasnovski/mini.diff',
        config = function()
            require 'plugins.config.mini-diff'.setup()
        end,
        cond = user.settings.diff == 'mini',
    },
    {
        'NMAC427/guess-indent.nvim',
        config = function()
            require 'plugins.config.guess-indent'.setup()
        end,
        cond = user.settings.guess_indent,
    },
    {
        'echasnovski/mini.files',
        config = function()
            require 'plugins.config.mini-files'.setup()
        end,
    },
    {
        'echasnovski/mini.bufremove',
        config = function()
            require 'plugins.config.mini-bufremove'.setup()
        end,
        cond = user.settings.buffer_deleter == 'mini',
    },
    {
        'echasnovski/mini.bracketed',
        config = function()
            require 'plugins.config.mini-bracketed'.setup()
        end,
    },
    {
        'echasnovski/mini.ai',
        config = function()
            require 'plugins.config.mini-ai'.setup()
        end,
        cond = user.settings.targets == 'mini',
    },
    {
        'sitiom/nvim-numbertoggle',
        cond = user.settings.line_number.auto_toggle,
    },
    {
        'folke/todo-comments.nvim',
        event = 'VimEnter',
        config = function()
            require 'plugins.config.todo-comments'.setup()
        end,
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
    },
    {
        'echasnovski/mini.surround',
        config = function()
            require 'plugins.config.mini-surround'.setup()
        end,
        cond = user.settings.targets == 'mini',
    },
    {
        'stevearc/oil.nvim',
        lazy = false,
        config = function()
            require 'plugins.config.oil'.setup()
        end,
        dependencies = {
            m.icons_plugin[user.settings.icons],
        },
        cond = user.settings.oil,
    },
    {
        'nvim-tree/nvim-web-devicons',
        cond = user.settings.icons == 'nvim-web-devicons',
    },
    {
        'echasnovski/mini.icons',
        opts = {},
        cond = user.settings.icons == 'mini',
    },

    require 'plugins.config.snacks'.lazy(),

    -- Vim Plugins
    {
        'junegunn/fzf.vim',
        init = function()
            require 'plugins.config.fzf'.init()
        end,
        dependencies = {
            'junegunn/fzf',
        },
        cond = user.settings.finder == 'fzf-lua' or user.settings.finder == 'fzf',
    },
    {
        'tpope/vim-fugitive',
        config = function()
            require 'plugins.config.fugitive'.setup()
        end,
    },
    {
        --'mg979/vim-visual-multi',
        'eyalz800/vim-visual-multi',
        init = function()
            require 'plugins.config.visual-multi'.init()
        end,
        config = function()
            require 'plugins.config.visual-multi'.setup()
        end,
    },
    {
        'ntpeters/vim-better-whitespace',
        event = { 'BufRead', 'VeryLazy' },
        init = function()
            require 'plugins.config.better-whitespace'.init()
        end,
        config = function()
            require 'plugins.config.better-whitespace'.setup()
        end,
    },
    {
        'puremourning/vimspector',
        event1337= 'VeryLazy',
        init = function()
            require 'plugins.config.vimspector'.init()
        end,
        config = function()
            require 'plugins.config.vimspector'.setup()
        end,
        cond = user.settings.debugging == 'vimspector',
    },
    {
        'airblade/vim-gitgutter',
        init = function()
            require 'plugins.config.gitgutter'.init()
        end,
        cond = user.settings.git_plugin == 'gitgutter',
    },
    {
        'vim-airline/vim-airline',
        init = function()
            require 'plugins.config.airline'.init()
        end,
        cond = user.settings.line == 'airline'
    },
    {
        'preservim/nerdtree',
        init = function()
            require 'plugins.config.nerdtree'.init()
        end,
        dependencies = {
            {
                'ryanoasis/vim-devicons',
                init = function()
                    require 'plugins.config.devicons'.init()
                end
            },
            'tiagofumo/vim-nerdtree-syntax-highlight',
            'Xuyuanp/nerdtree-git-plugin'
        },
        cond = user.settings.file_explorer == 'nerdtree',
    },
    {
        'majutsushi/tagbar',
        init = function()
            require 'plugins.config.tagbar'.init()
        end,
        cond = user.settings.code_explorer == 'tagbar',
    },
    {
        'neoclide/coc.nvim',
        branch = 'release',
        init = function()
            require 'plugins.config.coc'.init()
        end,
        dependencies = {
            {
                'eyalz800/vim-ultisnips',
                init = function()
                    require 'plugins.config.ultisnips'.init()
                end,
            },
        },
        cond = user.settings.lsp == 'coc'
    },
    {
        'tmsvg/pear-tree',
        init = function()
            require 'plugins.config.pear-tree'.init()
        end,
        cond = user.settings.pairs == 'pear-tree',
    },
    {
        'troydm/zoomwintab.vim',
        init = function()
            require 'plugins.config.zoomwintab'.init()
        end,
        cond = user.settings.zoom == 'zoomwintab',
    },
    {
        'christoomey/vim-tmux-navigator',
        init = function()
            require 'plugins.config.tmux-navigator'.init()
        end,
    },
    {
        'skywind3000/asynctasks.vim',
        init = function()
            require 'plugins.config.asynctasks'.init()
        end,
        dependencies = {
            'skywind3000/asyncrun.vim',
        },
    },
    {
        'tpope/vim-abolish',
        init = function()
            require 'plugins.config.abolish'.init()
        end,
        event1337= 'VeryLazy',
    },
    {
        'jreybert/vimagit',
        init = function()
            require 'plugins.config.magit'.init()
        end,
        cmd = { 'Magit', 'MagitOnly' }
    },
    {
        'aklt/plantuml-syntax',
        init = function()
            require 'plugins.config.plantuml-syntax'.init()
        end,
    },
    {
        'ludovicchabant/vim-gutentags',
        cond = user.settings.enable_gutentags == true,
    },
    {
        'antoinemadec/coc-fzf',
        branch = 'release',
        cond = user.settings.lsp == 'coc'
    },
    {
        'octol/vim-cpp-enhanced-highlight',
        cond = not require 'plugins.lsp'.semantic_highlighting or user.settings.treesitter
    },
    {
        'voldikss/vim-floaterm',
        cond = user.settings.terminal == 'floaterm' or user.settings.float_term == 'floaterm',
    },
    {
        'tpope/vim-surround',
        cond = user.settings.surround == 'vim-surround',
    },
    {
        'j5shi/CommandlineComplete.vim',
        event1337= 'VeryLazy',
    },
    {
        --'famiu/bufdelete.nvim',
        'eyalz800/bufdelete.nvim',
        cond = user.settings.buffer_deleter == 'bufdelete',
    },
    {
        'wellle/targets.vim',
        cond = user.settings.targets == 'targets.vim',
    },
    {
        'yazgoo/yank-history',
    },
    {
        'vim-python/python-syntax',
        cond = not require 'plugins.lsp'.semantic_highlighting or user.settings.treesitter
    },
    {
        'mbbill/undotree',
    },
    {
        'tpope/vim-obsession',
        cmd = 'Obsession',
    },
    {
        'will133/vim-dirdiff',
        cmd = 'DirDiff',
    },
    {
        'tpope/vim-commentary',
        cond = user.settings.comment == 'vim-commentary',
    },
    {
        'easymotion/vim-easymotion',
        cond = user.settings.jumper == 'easymotion-sneak',
    },
    {
        'justinmk/vim-sneak',
        cond = user.settings.jumper == 'easymotion-sneak',
    },
    {
        'erig0/cscope_dynamic',
        build = require 'lib.os-bin'.sed .. ' -i "s/call s:runShellCommand/call system/g" ./plugin/cscope_dynamic.vim',
        event = 'VeryLazy',
        cond = user.settings.cscope_dynamic,
    },
    {
        'haya14busa/incsearch.vim',
        cond = user.settings.jumper ~= 'flash' and user.settings.jumper ~= '',
    },
}

return m
