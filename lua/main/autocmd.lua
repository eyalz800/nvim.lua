local m = {}
local v = require 'vim'
local colors = require 'plugins.colors'
local whitespace = require 'plugins.whitespace'
local lsp = require 'plugins.lsp'
local large_files = require 'plugins.large_files'
local syntax = require 'plugins.syntax'
local binary_view = require 'plugins.binary_view'
local doc_reader = require 'plugins.doc_reader'
local user = require 'user'
local augroup = v.api.nvim_create_augroup
local autocmd = v.api.nvim_create_autocmd
local opt_local = v.opt_local

m.setup = function()
    local indentation = augroup('init.lua.file_indentatoin', {})
    autocmd('filetype', {
        pattern = { 'c', 'cpp' },
        group = indentation,
        callback = function()
            opt_local.cindent = true
        end
    })
    autocmd('filetype', {
        pattern = { 'make' },
        group = indentation,
        callback = function()
            opt_local.expandtab = false
            opt_local.autoindent = true
        end
    })

    autocmd('filetype', {
        pattern = 'cpp',
        group = augroup('init.lua.file_indentation', {}),
        callback = function()
            opt_local.matchpairs:append '<:>'
        end
    })

    autocmd({ 'BufRead', 'BufNewFile' },
        {
            pattern = { '*.cppm', "*.ixx" },
            group = augroup('init.lua.cpp_module_types', {}),
            callback = function()
                opt_local.filetype = 'cpp'
            end
        })

    autocmd('TermOpen', {
        group = augroup('init.lua.terminal_auto_commands', {}),
        callback = function()
            opt_local.number = false
            opt_local.relativenumber = false
            opt_local.signcolumn = 'no'
            whitespace.disable()
        end
    })

    autocmd('colorschemepre', { group = augroup('init.lua.colorscheme_pre', {}), callback = colors.pre_switch_color })
    autocmd('colorscheme', { group = augroup('init.lua.colorscheme', {}), callback = colors.post_switch_color })

    local lsp_was_enabled = nil
    if user.settings.lsp == 'coc' then
        autocmd('User',
            {
                pattern = 'visual_multi_start',
                group = augroup('init.lua.visual_multi_start.lsp', {}),
                callback = function()
                    lsp_was_enabled = lsp.is_enabled()
                    lsp.disable()
                end
            })
    end

    autocmd('User',
        {
            pattern = 'visual_multi_exit',
            group = augroup('init.lua.visual_multi_exit.lsp', {}),
            callback = function()
                if lsp_was_enabled then
                    lsp.enable()
                end
            end
        })

    if user.settings.line == 'lualine' then
        local lualine = require 'lualine'
        autocmd('User',
            {
                pattern = 'visual_multi_start',
                group = augroup('init.lua.visual_multi_start.line', {}),
                callback = function()
                    lualine.hide()
                end
            })
        autocmd('User',
            {
                pattern = 'visual_multi_exit',
                group = augroup('init.lua.visual_multi_exit.line', {}),
                callback = function()
                    lualine.hide({ unhide = true })
                end
            })
    end

    autocmd('filetype', {
        pattern = 'nerdtree',
        group = augroup('init.lua.nerdtree', {}),
        callback = function()
            opt_local.signcolumn = 'no'
        end
    })

    autocmd('BufReadPre', { group = augroup('init.lua.large_files_pre', {}), callback = large_files.on_buf_read_pre })
    autocmd('BufReadPost', { group = augroup('init.lua.large_files_post', {}), callback = large_files.on_buf_read_post })
    autocmd('syntax', { pattern = 'python', group = augroup('init.lua.syntax.python', {}),
        callback = syntax.apply_py_syntax })
    autocmd('syntax',
        { pattern = { 'c', 'cpp' }, group = augroup('init.lua.syntax.c_cpp', {}), callback = syntax
        .apply_c_and_cpp_syntax })
    autocmd('BufReadPost', { group = augroup('init.lua.binary_view.r.po', {}), callback = binary_view.on_buf_read_post })
    autocmd('BufWritePre', { group = augroup('init.lua.binary_view.w.pr', {}), callback = binary_view.on_buf_write_pre })
    autocmd('BufWritePost', { group = augroup('init.lua.binary_view.w.po', {}), callback = binary_view.on_buf_write_post })
    autocmd('BufReadPost',
        { pattern = doc_reader.doc_patterns, group = augroup('init.lua.doc_reader', {}),
            callback = doc_reader.on_buf_read_post })
    autocmd('User',
        { pattern = 'LazyUpdatePre', group = augroup('init.lua.lazy_update_pre', {}),
            callback = require 'plugins.lazy'.on_update })
    autocmd('filetype',
        { pattern = 'qf', group = augroup('init.lua.quickfix', {}), callback = require 'plugins.quickfix'.on_open })
    autocmd('filetype', { pattern = 'help', group = augroup('init.lua.help', {}), callback = require 'plugins.help'
    .on_open })

    if lsp.diagnostic_hover then
        autocmd('CursorHold', { group = augroup('init.lua.lsp_diagnostics_hover', {}), callback = lsp.diagnostic_hover })
    end

    autocmd('User',
        { pattern = 'VeryLazy', group = augroup('init.lua.terminal_color', {}),
            callback = require 'plugins.colors'.load_terminal_colors })

    if user.settings.debugger == 'vimspector' then
        autocmd('filetype',
            { pattern = 'VimspectorPrompt', group = augroup('init.lua.vimspector.prompt', {}),
                callback = require 'plugins.config.vimspector'.on_initialize_prompt })
        autocmd('User',
            { pattern = 'VimspectorUICreated', group = augroup('init.lua.vimspector.ui_created', {}),
                callback = require 'plugins.config.vimspector'.on_ui_created })
        autocmd('User',
            { pattern = 'visual_multi_exit', group = augroup('init.lua.vimspector.visual_multi_exit', {}),
                callback = require 'plugins.config.vimspector'.on_visual_multi_exit })
    elseif user.settings.debugger == 'dap' then
        autocmd('filetype',
            { pattern = 'dap-repl', group = augroup('init.lua.dap.repl_complete', {}),
                callback = require 'plugins.config.dap'.on_dap_repl_attach })
    end

    autocmd({ 'WinEnter' }, { pattern = 'term://*', group = augroup('init.lua.term.enter', {}), command = 'startinsert' })

    autocmd('filetype', {
        pattern = 'fugitiveblame',
        group = augroup('init.lua.fugitive-diffview', {}),
        command =
        [=[nnoremap <buffer> <silent> q <cmd>q<cr> | nnoremap <buffer> <silent> d <cmd>silent exec 'norm! 0eb"xyw' <bar> wincmd l <bar> silent exec 'DiffviewFileHistory % --range='.getreg('x')<cr>]=]
    })

    if user.settings.bar == 'barbecue' then
        if user.settings.lsp == 'nvim' then
            autocmd({ 'WinResized', 'BufWinEnter', 'CursorHold', 'InsertLeave' },
                { group = augroup('init.lua.barbecue.updater', {}), callback = require 'plugins.config.barbecue'.on_update })
        end

        autocmd('filetype', {
            pattern = 'fugitiveblame',
            group = augroup('init.lua.fugitive-barbecue', {}),
            callback = function()
                v.wo.winbar = '  Blame'
            end
        })

        if user.settings.codecompanion then
            autocmd('User', {
                pattern = 'CodeCompanionDiffAttached',
                group = augroup('init.lua.codecompanion-barbecue', {}),
                callback = function(data)
                    local winid = vim.fn.win_getid(data.winnr)
                    v.wo[winid].winbar = ' Code Companion '
                end
            })
        end
    end
end

return m
