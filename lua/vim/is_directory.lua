local m = {}
m.is_directory = function(str)
    return vim.fn.isdirectory(str) ~= 0
end

return m
