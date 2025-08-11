local m = {}
m.file_readable = function(str)
    return vim.fn.filereadable(str) ~= 0
end

return m
