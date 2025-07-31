local m = {}
m.has = function(str)
    return vim.fn.has(str) ~= 0
end

return m
