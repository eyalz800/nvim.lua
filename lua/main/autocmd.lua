local m = {}
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local opt_local = vim.opt_local

m.setup = function()
    autocmd('filetype', {
        pattern = { 'c', 'cpp' },
        group = augroup('init.lua.autocmd.c-cpp-indentation', {}),
        callback = function()
            opt_local.cindent = true
            opt_local.formatoptions:remove('o')
        end
    })

    autocmd('filetype', {
        pattern = { 'make' },
        group = augroup('init.lua.autocmd.make-indentation', {}),
        callback = function()
            opt_local.expandtab = false
            opt_local.autoindent = true
        end
    })

    autocmd('filetype', {
        pattern = 'cpp',
        group = augroup('init.lua.autocmd.cpp-matchpairs', {}),
        callback = function()
            opt_local.matchpairs:append '<:>'
        end
    })

    autocmd({ 'bufread', 'bufnewfile' }, {
        pattern = { '*.cppm', '*.ixx' },
        group = augroup('init.lua.autocmd.cpp-module-types', {}),
        callback = function()
            opt_local.filetype = 'cpp'
        end
    })

    autocmd('termopen', {
        group = augroup('init.lua.autocmd.terminal-generic', {}),
        callback = function()
            opt_local.number = false
            opt_local.relativenumber = false
            opt_local.signcolumn = 'no'
        end
    })

    autocmd({ 'winenter' }, {
        pattern = 'term://*',
        group = augroup('init.lua.autocmd.term.enter', {}),
        command = 'startinsert'
    })
end

return m
