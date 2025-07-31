local m = {}
local cmd = require 'vim.cmd'.silent
local exists = require 'vim.exists'.exists

vim.g.tagbar_width = 30
vim.g.tagbar_indent = 0
vim.g.tagbar_compact = 2
vim.g.tagbar_iconchars = {'', ''}

m.open = function(_)
    cmd 'TagbarOpenAutoClose'
end

m.close = function()
    cmd 'TagbarClose'
end

m.is_open = function()
    return exists '*tagbar#IsOpen()' and vim.fn['tagbar#IsOpen()'] ~= 0
end

m.toggle = function()
    cmd 'TagbarToggle'
end

return m

