local m = {}
if vim.loop.os_uname().sysname == "Windows_NT" then
    m.os = "Windows"
else
    m.os = vim.fn.substitute(vim.fn.system('uname'), '\n', '', '')
end

return m
