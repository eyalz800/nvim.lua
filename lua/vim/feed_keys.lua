local m = {}
m.feed_keys = function(keys, mode)
	mode = mode or 'n'
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), mode, false)
end

m.plug = function(plug)
    m.feed_keys('<plug>(' .. plug .. ')')
end

return m
