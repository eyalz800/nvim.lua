local m = {}
local cmd = require 'vim.cmd'.silent

vim.g.better_whitespace_filetypes_blacklist = {'diff', 'gitcommit', 'git', 'unite', 'qf', 'help', 'VimspectorPrompt', 'xxd', 'Outline' }

m.setup = function()
    vim.api.nvim_create_autocmd('termopen', {
        group = vim.api.nvim_create_augroup('init.lua.terminal-disable-whitespace', {}),
        callback = function()
            m.disable()
        end
    })
end

m.enable = function()
    cmd 'EnableWhitespace'
end

m.disable = function()
    cmd 'DisableWhitespace'
end

m.toggle = function()
    cmd 'ToggleWhitespace'
end

m.strip = function()
    cmd 'StripWhitespace'
end

return m
