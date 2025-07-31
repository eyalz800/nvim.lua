local m = {}
m.exists = function(str)
    return vim.fn.exists(str) ~= 0
end

return m
