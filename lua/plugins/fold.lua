local m = {}
m.toggle = function()
    if vim.o.foldlevel == 0 then
        vim.o.foldlevel = 1000
    else
        vim.o.foldlevel = 0
    end
end

return m
