local m = {}
m.executable = function(str)
    return vim.fn.executable(str) ~= 0
end

return m
