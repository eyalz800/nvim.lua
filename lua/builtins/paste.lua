local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent

local sign_column = v.opt.signcolumn
local mouse = v.opt.mouse

m.on = false

m.toggle = function()
    if not m.on then
        m.on = true
        v.opt.signcolumn = 'no'
        v.opt.mouse = ''
    else
        m.on = false
        v.opt.signcolumn = sign_column
        v.opt.mouse = mouse
    end
    cmd 'set paste!'
    cmd 'set number!'
end

return m
