local m = {}
m.setup = function()
    require 'Comment'.setup(m.config())
    vim.keymap.del('x', 'gcb')
end

m.config = function()
    return {
        toggler = {
            line = 'gcc',
            block = 'gcb',
        },
        opleader = {
            line = 'gc',
            block = 'gcb',
        },
    }
end

return m

