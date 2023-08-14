local m = {}
local v = require 'vim'
local user = require 'user'

v.g['airline#extensions#whitespace#checks'] = {'indent', 'trailing', 'mixed-indent-file', 'conflicts'}
v.g['airline#extensions#whitespace#trailing_format'] = 'tr[%s]'
v.g['airline#extensions#whitespace#mixed_indent_file_format'] = 'mi[%s]'
v.g['airline#extensions#whitespace#mixed_indent_format'] = 'mi[%s]'
v.g['airline#extensions#whitespace#conflicts_format'] = 'conflict[%s]'
v.g['airline_theme_patch_func'] = 'Init_lua_airline_theme_patch'
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

v.cmd [[
function! Init_lua_airline_theme_patch(palette)
    if g:airline_theme == 'codedark'
        let airline_error = ['#FFFFFF', '#F44747', 0, 0]
        let airline_warning = ['#FFFFFF', '#F44747', 0, 0]

        let a:palette.normal.airline_warning = airline_warning
        let a:palette.normal.airline_error = airline_error
        let a:palette.normal_modified.airline_warning = airline_warning
        let a:palette.normal_modified.airline_error = airline_error
        let a:palette.insert.airline_warning = airline_warning
        let a:palette.insert.airline_error = airline_error
        let a:palette.insert_modified.airline_warning = airline_warning
        let a:palette.insert_modified.airline_error = airline_error
        let a:palette.replace.airline_warning = airline_warning
        let a:palette.replace.airline_error = airline_error
        let a:palette.replace_modified.airline_warning = airline_warning
        let a:palette.replace_modified.airline_error = airline_error
        let a:palette.visual.airline_warning = airline_warning
        let a:palette.visual.airline_error = airline_error
        let a:palette.visual_modified.airline_warning = airline_warning
        let a:palette.visual_modified.airline_error = airline_error
        let a:palette.inactive.airline_warning = airline_warning
        let a:palette.inactive.airline_error = airline_error
        let a:palette.inactive_modified.airline_warning = airline_warning
        let a:palette.inactive_modified.airline_error = airline_error
    elseif g:airline_theme == 'tokyonight'
        let airline_error = ['#000000', '#db4b4b', '0', '0']
        let airline_warning = ['#000000', '#e0af68', '0', '0']

        let a:palette.normal.airline_warning = airline_warning
        let a:palette.normal.airline_error = airline_error
        let a:palette.insert.airline_warning = airline_warning
        let a:palette.insert.airline_error = airline_error
        let a:palette.replace.airline_warning = airline_warning
        let a:palette.replace.airline_error = airline_error
        let a:palette.visual.airline_warning = airline_warning
        let a:palette.visual.airline_error = airline_error
        let a:palette.inactive.airline_warning = airline_warning
        let a:palette.inactive.airline_error = airline_error
    elseif g:airline_theme == 'github'
        let airline_insert_1 = ['#ffffff', '#ef5939', '0', '0']
        let airline_insert_2 = ['#dddddd', '#404040', '0', '0']
        let airline_insert_3 = ['#000000', '#dddddd', '0', '0']
        let a:palette.insert = airline#themes#generate_color_map(airline_insert_1, airline_insert_2, airline_insert_3)

        let airline_visual_1 = ['#ffffff', '#159828', '0', '0']
        let airline_visual_2 = ['#dddddd', '#404040', '0', '0']
        let airline_visual_3 = ['#000000', '#dddddd', '0', '0']
        let a:palette.visual = airline#themes#generate_color_map(airline_visual_1, airline_visual_2, airline_visual_3)
    endif
endfunction
]]

return m
