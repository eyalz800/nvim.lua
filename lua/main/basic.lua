local m = {}
local opt = vim.opt

local user = require 'user'
local has = require 'vim.has'.has
local exists = require 'vim.exists'.exists
local stdpath = vim.fn.stdpath

m.setup = function()
    if not user.settings.treesitter then
        vim.cmd 'syntax enable'
    end

    vim.cmd 'filetype plugin indent on'

    opt.ignorecase = true -- Ignore case
    opt.autoindent = true -- Automatic indendation
    opt.expandtab = user.settings.expand_tabs -- Expands tabs to spaces
    opt.ignorecase = true -- Ignore case
    opt.smartcase = true -- Smart case
    opt.autoindent = true -- Automatic indentation
    opt.cinoptions = 'g0N-sE-s' -- Do not indent namespaces/extern in cindent
    opt.backspace = 'indent,eol,start' -- Make backspace work like in most programs
    opt.ruler = true -- Show line and column of cursor position
    opt.showcmd = true -- Show command line in the last line of the screen
    opt.incsearch = true -- Incrementally search words
    opt.hlsearch = true -- Highlight searches
    opt.shiftwidth = user.settings.indentation -- Shift adds indentation spaces.
    opt.tabstop = user.settings.indentation -- Tab is indentation columns
    opt.softtabstop = user.settings.indentation -- Tab is indentation columns
    opt.cmdheight = 1 -- Command line height is 1
    opt.number = user.settings.line_number.number -- Shows line numbers
    opt.relativenumber = user.settings.line_number.relative -- Show relative line numbers
    opt.wildmenu = true -- Enhanced completion menu
    --opt.wildmode = 'list:longest,full' -- Enhanced completion menu
    opt.wildoptions = 'pum' -- Use popup menu
    opt.completeopt = 'longest,menuone,preview' -- Enhanced completion menu
    opt.wrap = false -- Do not wrap text
    opt.updatetime = 200 -- Write swp file and trigger cursor hold events every X ms
    opt.shortmess:append "cI" -- Disable splash
    opt.hidden = true -- Allow hidden buffers with writes
    opt.cursorline = true -- Activate cursor line
    opt.errorbells = false -- Do not play bell sounds
    opt.visualbell = true -- Do not play bell sounds
    opt.belloff = 'all' -- Turn off all bells
    opt.ttyfast = true -- Fast terminal
    --opt.re = 1 -- Regex engine 1
    opt.foldmethod = 'marker' -- Marker based fold method
    opt.keymodel = 'startsel' -- Shifted special key starts selection
    opt.laststatus = 2 -- Add status line
    opt.showmode = false -- Do not show command/insert/normal status
    opt.ttimeoutlen = 10 -- Responsive escape
    opt.fillchars = 'vert:│' -- Bar for vertical split
    opt.swapfile = user.settings.swap_files -- Swap files support
    opt.signcolumn = 'yes:2' -- Sign column width
    opt.mouse = 'a' -- Mouse
    opt.mousemoveevent = true -- Mouse movement
    opt.splitkeep = 'screen' -- Keep text on the same screen line
    opt.shada:append({'r*://'}) -- Ignore files from shada
    opt.splitright = true -- Open new splits on the right
    opt.splitbelow = true -- Open new splits on the bottom
    opt.jumpoptions = user.settings.jumpoptions or '' -- Adjust jumplist options

    if exists('+shellslash') then -- Use forward slash for directories
        opt.shellslash = true
    end

    opt.undodir = stdpath('data') .. '/installation/undo'
    opt.undolevels = 10000 -- Undo levels
    opt.undofile = true -- Enable undo file

    vim.g.loaded_gzip = 0 -- Disable loading gzip plugin"
    vim.g.editorconfig = user.settings.respect_editor_config -- Respect or ignore editor config file

    -- Gui colors
    if has('termguicolors') == 1 and user.settings.gui_colors then
        opt.termguicolors = true -- Term gui colors
    end
end

return m
