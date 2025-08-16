local m = {}
local user = require 'user'

m.init = function()
    vim.g['airline#extensions#whitespace#checks'] = { 'indent', 'trailing', 'mixed-indent-file', 'conflicts' }
    vim.g['airline#extensions#whitespace#trailing_format'] = 'tr[%s]'
    vim.g['airline#extensions#whitespace#mixed_indent_file_format'] = 'mi[%s]'
    vim.g['airline#extensions#whitespace#mixed_indent_format'] = 'mi[%s]'
    vim.g['airline#extensions#whitespace#conflicts_format'] = 'conflict[%s]'
    vim.g['airline#extensions#zoomwintab#enabled'] = 1
    vim.g['airline#extensions#zoomwintab#status_zoomed_in'] = '(zoom)'
    if user.settings.buffer_line == 'airline' then
        vim.g['airline#extensions#tabline#enabled'] = 1
        vim.g['airline#extensions#tabline#tabs_label'] = ''
        vim.g['airline#extensions#tabline#buffers_label'] = ''
        vim.g['airline#extensions#tabline#show_splits'] = 0
        vim.g['airline#extensions#tabline#show_close_button'] = 0
        vim.g['airline#extensions#tabline#show_tab_type'] = 0
        vim.g['airline#extensions#tabline#show_tab_nr'] = 0
        vim.g['airline#extensions#tabline#show_buffers'] = 1
        vim.g['airline#extensions#tabline#fnamecollapse'] = 1
        vim.g['airline#extensions#tabline#fnamemod'] = ':t'
    end
    vim.g['airline_powerline_fonts'] = user.settings.powerline
end

m.next_buffer = '<plug>AirlineSelectNextTab'
m.prev_buffer = '<plug>AirlineSelectPrevTab'

m.delete_buffer = function(id)
    require 'plugins.buffer-delete'.delete(id or 0)
    vim.fn['airline#extensions#tabline#buflist#clean']()
end

m.switch_to_buffer = function(number)
    return '<plug>AirlineSelectTab' .. number
end

return m
