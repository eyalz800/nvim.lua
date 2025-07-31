local m = {}
m.setup = function()
    if vim.env.IS_INSIDE_VIM == '1' then
        m.is_nested = true
    else
        vim.env.IS_INSIDE_VIM = '1'
        m.is_nested = false
    end
end

return m
