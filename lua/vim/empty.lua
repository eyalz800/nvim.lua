local m = {}
m.empty = function(str)
    return vim.fn.empty(str) ~= 0
end

return m
