local m = {}
local v = require 'vim'
local user = require 'user'
local cmd = require 'vim.cmd'.silent

v.g['airline#extensions#whitespace#checks'] = {'indent', 'trailing', 'mixed-indent-file', 'conflicts'}
v.g['airline#extensions#whitespace#trailing_format'] = 'tr[%s]'
v.g['airline#extensions#whitespace#mixed_indent_file_format'] = 'mi[%s]'
v.g['airline#extensions#whitespace#mixed_indent_format'] = 'mi[%s]'
v.g['airline#extensions#whitespace#conflicts_format'] = 'conflict[%s]'
v.g['airline#extensions#zoomwintab#enabled'] = 1
v.g['airline#extensions#zoomwintab#status_zoomed_in'] = '(zoom)'
if user.settings.buffer_line == 'airline' then
    v.g['airline#extensions#tabline#enabled'] = 1
    v.g['airline#extensions#tabline#tabs_label'] = ''
    v.g['airline#extensions#tabline#buffers_label'] = ''
    v.g['airline#extensions#tabline#show_splits'] = 0
    v.g['airline#extensions#tabline#show_close_button'] = 0
    v.g['airline#extensions#tabline#show_tab_type'] = 0
    v.g['airline#extensions#tabline#show_tab_nr'] = 0
    v.g['airline#extensions#tabline#show_buffers'] = 1
    v.g['airline#extensions#tabline#fnamecollapse'] = 1
    v.g['airline#extensions#tabline#fnamemod'] = ':t'
end
v.g['airline_powerline_fonts'] = user.settings.powerline

m.next_buffer = '<plug>AirlineSelectNextTab'
m.prev_buffer = '<plug>AirlineSelectPrevTab'

m.delete_buffer = function()
    cmd 'Bclose'
    v.fn['airline#extensions#tabline#buflist#clean']()
end

return m
