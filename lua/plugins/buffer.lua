local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent

m.delete_buffer = function()
    cmd 'BD'
    v.fn['airline#extensions#tabline#buflist#clean']()
end

return m
