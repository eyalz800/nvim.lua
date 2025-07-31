local m = {}
m.status = { on = false }

m.toggle = function()
    if not m.status.on then
        m.status = {
            on = false,
            signcolumn = vim.o.signcolumn,
            statuscolumn = vim.o.statuscolumn,
            mouse = vim.o.mouse,
            number = vim.o.number,
            relativenumber = vim.o.relativenumber,
        }
        vim.opt.signcolumn = 'no'
        vim.opt.statuscolumn = ''
        vim.opt.mouse = ''
        vim.opt.number = false
        vim.opt.relativenumber = false
        vim.opt.paste = true
        m.status.on = true
    else
        vim.opt.signcolumn = m.status.signcolumn
        vim.opt.statuscolumn = m.status.statuscolumn
        vim.opt.mouse = m.status.mouse
        vim.opt.number = m.status.number
        vim.opt.relativenumber = m.status.relativenumber
        vim.opt.paste = false
        m.status.on = false
    end
end

return m
