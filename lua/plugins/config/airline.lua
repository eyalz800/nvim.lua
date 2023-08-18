local m = {}
local v = require 'vim'
local user = require 'user'

v.g['airline#extensions#whitespace#checks'] = {'indent', 'trailing', 'mixed-indent-file', 'conflicts'}
v.g['airline#extensions#whitespace#trailing_format'] = 'tr[%s]'
v.g['airline#extensions#whitespace#mixed_indent_file_format'] = 'mi[%s]'
v.g['airline#extensions#whitespace#mixed_indent_format'] = 'mi[%s]'
v.g['airline#extensions#whitespace#conflicts_format'] = 'conflict[%s]'
v.g['airline#extensions#zoomwintab#enabled'] = 1
v.g['airline#extensions#zoomwintab#status_zoomed_in'] = '(zoom)'
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
v.g['airline_powerline_fonts'] = user.settings.powerline

m.next_tab = '<plug>AirlineSelectNextTab'
m.prev_tab = '<plug>AirlineSelectPrevTab'

return m
