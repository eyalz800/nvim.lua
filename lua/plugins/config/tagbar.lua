local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent
local exists = require 'vim.exists'.exists

v.g.tagbar_width = 30
v.g.tagbar_indent = 0
v.g.tagbar_compact = 2
v.g.tagbar_iconchars = {'', ''}

m.open = function()
    cmd 'TagbarOpenAutoClose'
end

m.close = function()
    cmd 'TagbarClose'
end

m.is_open = function()
    return exists '*tagbar#IsOpen()' and v.fn['tagbar#IsOpen()'] ~= 0
end

m.toggle = function()
    cmd 'TagbarToggle'
end

return m

