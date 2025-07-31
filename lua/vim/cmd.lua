local m = {}
m.cmd = vim.cmd

m.silent = function(str)
    vim.cmd('silent ' .. str)
end

return m
