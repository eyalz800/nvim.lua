local m = {}
local v = require 'vim'
local user = require 'user'

---@diagnostic disable: different-requires

m.setup = function()
    local lazy_conf = require 'plugins.config.lazy'
    require 'lazy'.setup(m.plugins, lazy_conf.config())
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
        'folke/tokyonight.nvim',
        priority = 1000,
        config = function()
            require 'plugins.colors.tokyonight'.setup()
        end,
    },
    {
        'Mofiqul/vscode.nvim',
        config = function()
            require 'plugins.colors.vscode'.setup()
        end,
    },
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        config = function()
            require 'plugins.colors.catppuccin'.setup()
        end,
    },
    {
        'folke/which-key.nvim',
        config = function()
            require 'plugins.config.which-key'.setup()
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
        'j-hui/fidget.nvim',
        config = function()
            require 'plugins.config.fidget'.setup()
        end,
        cond = user.settings.lsp == 'nvim',
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            {
                'williamboman/mason-lspconfig.nvim',
                dependencies = {
                    'williamboman/mason.nvim'
                },
                cond = user.settings.lsp == 'nvim',
            },
            'j-hui/fidget.nvim',
            {
                'folke/neoconf.nvim',
                config = function()
                    require 'plugins.config.neoconf'.setup()
                end,
                cond = user.settings.lsp == 'nvim',
            },
            {
                'folke/neodev.nvim',
                config = function()
                    require 'plugins.config.neodev'.setup()
                end,
                cond = user.settings.lsp == 'nvim',
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
        },
        config = function()
            require 'plugins.config.nvim-lsp'.setup()
        end,
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
        'lewis6991/gitsigns.nvim',
        config = function()
            require 'plugins.config.gitsigns'.setup()
        end,
        cond = user.settings.git_plugin == 'gitsigns'
    },
    {
        'airblade/vim-gitgutter',
        cond = user.settings.git_plugin == 'gitgutter',
    },
    {
        'vim-airline/vim-airline',
        cond = user.settings.line == 'airline'
    },
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require 'plugins.config.lualine'.setup()
        end,
        dependencies = { 'nvim-tree/nvim-web-devicons' },
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
            'nvim-tree/nvim-web-devicons',
        },
        cond = user.settings.bar == 'barbecue' and user.settings.lsp == 'nvim'
    },
    {
        'nvim-tree/nvim-tree.lua',
        config = function()
            require 'plugins.config.nvim-tree'.setup()
        end,
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        cond = user.settings.file_explorer == 'nvim-tree',
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
            require 'plugins.config.bufferline'.setup()
        end,
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        cond = user.settings.buffer_line == 'bufferline',
    },
    {
        'majutsushi/tagbar',
        cond = user.settings.code_explorer == 'tagbar',
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
        'ludovicchabant/vim-gutentags',
        cond = user.settings.enable_gutentags == true,
    },
    {
        'junegunn/fzf',
        name = 'fzf',
        dir = '~/.fzf',
        build = './install --all',
    },
    {
        'junegunn/fzf.vim',
        dependencies = {
            'junegunn/fzf',
        },
    },
    {
        'ibhagwan/fzf-lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'junegunn/fzf',
        },
        config = function()
            require 'plugins.config.fzf-lua'.setup()
        end,
        cond = user.settings.finder == 'fzf-lua',
    },
    {
        'neoclide/coc.nvim',
        branch = 'release',
        cond = user.settings.lsp == 'coc'
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
        'akinsho/toggleterm.nvim',
        version = '*',
        config = function()
            require 'plugins.config.toggleterm'.setup()
        end,
        cond = user.settings.terminal == 'toggleterm',
    },
    {
        'tpope/vim-fugitive',
    },
    {
        'skywind3000/asyncrun.vim',
    },
    {
        'mg979/vim-visual-multi',
    },
    {
        'tmsvg/pear-tree',
        cond = user.settings.pairs == 'pear-tree',
    },
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = function()
            require 'plugins.config.nvim-autopairs'.setup()
        end,
        dependencies = {
            'hrsh7th/nvim-cmp',
        },
        cond = user.settings.pairs == 'nvim-autopairs',
    },
    {
        'tpope/vim-commentary',
        event = 'VeryLazy',
    },
    {
        'ntpeters/vim-better-whitespace',
    },
    {
        'troydm/zoomwintab.vim',
        event = 'VeryLazy',
        cond = user.settings.zoom == 'zoomwintab',
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
        'christoomey/vim-tmux-navigator',
    },
    {
        'tpope/vim-surround',
        event = 'VeryLazy',
    },
    {
        'j5shi/CommandlineComplete.vim',
        event = 'VeryLazy',
    },
    {
        'skywind3000/asynctasks.vim',
        event = 'VeryLazy',
    },
    {
        --'famiu/bufdelete.nvim',
        'eyalz800/bufdelete.nvim',
        event = 'VeryLazy',
    },
    {
        'tpope/vim-abolish',
        event = 'VeryLazy',
    },
    {
        'wellle/targets.vim',
        event = 'VeryLazy',
    },
    {
        'yazgoo/yank-history',
        event = 'VeryLazy',
    },
    {
        'vim-python/python-syntax',
        cond = not require 'plugins.lsp'.semantic_highlighting or user.settings.treesitter
    },
    {
        'jreybert/vimagit',
        cmd = { 'Magit', 'MagitOnly' }
    },
    {
        'mbbill/undotree',
        event = 'VeryLazy',
    },
    {
        'eyalz800/vim-ultisnips',
        event = 'VeryLazy',
        cond = user.settings.lsp == 'coc',
    },
    {
        'tpope/vim-obsession',
        cmd = 'Obsession',
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require 'plugins.config.indent-blankline'.setup()
        end,
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
        'easymotion/vim-easymotion',
        event = 'VeryLazy',
        cond = user.settings.jumper == 'easymotion-sneak',
    },
    {
        'justinmk/vim-sneak',
        event = 'VeryLazy',
        cond = user.settings.jumper == 'easymotion-sneak',
    },
    {
        'haya14busa/incsearch.vim',
        cond = user.settings.jumper ~= 'flash' and user.settings.jumper ~= '',
    },
    {
        'sindrets/diffview.nvim',
        config = function()
            require 'plugins.config.diffview'
        end,
        event = 'VeryLazy',
    },
    {
        'will133/vim-dirdiff',
        cmd = 'DirDiff',
    },
    {
        'erig0/cscope_dynamic',
        build = require 'lib.os_bin'.sed .. ' -i "s/call s:runShellCommand/call system/g" ./plugin/cscope_dynamic.vim',
        event = 'VeryLazy',
        cond = user.settings.cscope_dynamic,
    },
    {
        'metakirby5/codi.vim',
        cmd = 'Codi',
    },
    {
        'nvim-lua/plenary.nvim',
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
        'aklt/plantuml-syntax',
        config = function()
            v.g.plantuml_set_makeprg = 0
            v.g.plantuml_executable_script = ''
        end,
    },
    {
        'eyalz800/copilot.lua',
        --'zbirenbaum/copilot.lua',
        enabled = true,
        dependencies = {
            'hrsh7th/nvim-cmp',
        },
        cmd = 'Copilot',
        build = ':Copilot auth',
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
        'yetone/avante.nvim',
        build = 'make',
        event = 'VeryLazy',
        version = false, -- Never set this value to "*"! Never!
        ---@module 'avante'
        ---@type avante.Config
        opts = {
            -- add any opts here
            -- for example
            provider = 'claude',
            providers = {
                claude = {
                    endpoint = 'https://api.anthropic.com',
                    model = "claude-sonnet-4-20250514",
                    timeout = 30000, -- Timeout in milliseconds
                    extra_request_body = {
                        temperature = 0.75,
                        max_tokens = 20480,
                    },
                },
                moonshot = {
                    endpoint = 'https://api.moonshot.ai/v1',
                    model = 'kimi-k2-0711-preview',
                    timeout = 30000, -- Timeout in milliseconds
                    extra_request_body = {
                        temperature = 0.75,
                        max_tokens = 32768,
                    },
                },
            },
        },
        dependencies = {
            'nvim-lua/plenary.nvim',
            'MunifTanjim/nui.nvim',
            --- The below dependencies are optional,
            'echasnovski/mini.pick', -- for file_selector provider mini.pick
            'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
            'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
            'ibhagwan/fzf-lua', -- for file_selector provider fzf
            'stevearc/dressing.nvim', -- for input provider dressing
            'folke/snacks.nvim', -- for input provider snacks
            'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
            --'zbirenbaum/copilot.lua', -- for providers='copilot'
            'eyalz800/copilot.lua', -- for providers='copilot'
            {
                -- support for image pasting
                'HakonHarnes/img-clip.nvim',
                event = 'VeryLazy',
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
            {
                -- Make sure to set this up properly if you have lazy=true
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    file_types = { 'markdown', 'Avante' },
                },
                ft = { 'markdown', 'Avante' },
            },
        },
        cond = user.settings.avante,
    },
    {
        'milanglacier/minuet-ai.nvim',
        config = function()
            require 'plugins.config.minuet-ai'.setup()
        end,
        cond = user.settings.minuet_ai,
    },
}

return m
