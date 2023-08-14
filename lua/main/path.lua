local m = {}
local v = require 'vim'
local executable = require 'vim.executable'.executable
local file_readable = require 'vim.file_readable'.file_readable

local expand = v.fn.expand

v.env.PATH = expand('~/.vim/bin/lf') ..
    ':' .. expand('~/.vim/bin/llvm') ..
    ':' .. expand('~/.vim/bin/python') ..
    ':' .. v.env.PATH

if not executable('clangd') and file_readable('/usr/local/opt/llvm/bin/clangd') then
    v.env.PATH = v.env.PATH .. '/usr/local/opt/llvm/bin/clangd'
end

return m
