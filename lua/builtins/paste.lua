local m = {}
local v = require 'vim'

m.status = { on = false }

m.toggle = function()
    if not m.status.on then
        m.status = {
           on = false,
           signcolumn = v.o.signcolumn,
           statuscolumn = v.o.statuscolumn,
           mouse = v.o.mouse,
           number = v.o.number,
           relativenumber = v.o.relativenumber,
        }
        v.opt.signcolumn = 'no'
        v.opt.statuscolumn = ''
        v.opt.mouse = ''
		v.opt.number = false
		v.opt.relativenumber = false
        v.opt.paste = true
        m.status.on = true
    else
        v.opt.signcolumn = m.status.signcolumn
        v.opt.statuscolumn = m.status.statuscolumn
        v.opt.mouse = m.status.mouse
		v.opt.number = m.status.number
		v.opt.relativenumber = m.status.relativenumber
        v.opt.paste = false
        m.status.on = false
    end
end

return m
