local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent

v.g.better_whitespace_filetypes_blacklist = {'diff', 'gitcommit', 'git', 'unite', 'qf', 'help', 'VimspectorPrompt', 'xxd', 'Outline' }

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
