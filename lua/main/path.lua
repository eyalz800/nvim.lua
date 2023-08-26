local m = {}
local v = require 'vim'
local executable = require 'vim.executable'.executable

local stdpath = v.fn.stdpath

local data_path = stdpath 'data'

v.env.PATH = data_path .. '/installation/bin/programs' .. ':' ..
             data_path .. '/mason/bin' .. ':' ..
             v.env.PATH

if not executable('clangd') and v.loop.fs_stat('/usr/local/opt/llvm/bin/clangd') then
    v.env.PATH = v.env.PATH .. '/usr/local/opt/llvm/bin'
end

if not executable('clangd') and v.loop.fs_stat('/opt/homebrew/opt/llvm/bin/clangd') then
    v.env.PATH = v.env.PATH .. '/opt/homebrew/opt/llvm/bin'
end

return m
