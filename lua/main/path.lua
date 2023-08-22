local m = {}
local v = require 'vim'
local executable = require 'vim.executable'.executable
local file_readable = require 'vim.file_readable'.file_readable

local expand = v.fn.expand
local stdpath = v.fn.stdpath

v.env.PATH = stdpath('data') .. '/installation/bin/llvm' .. ':' .. v.env.PATH

if not executable('clangd') and file_readable('/usr/local/opt/llvm/bin/clangd') then
    v.env.PATH = v.env.PATH .. '/usr/local/opt/llvm/bin/clangd'
end

return m
