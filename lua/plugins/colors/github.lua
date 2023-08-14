local m = {}
local v = require 'vim'
local exec_detach = require 'lib.exec_detach'.exec_detach

m.configure = function()
    if v.o.background == 'dark' then
        v.opt.background = 'light'
        exec_detach('color github')
        return false
    end

    v.env.BAT_THEME = 'Monokai Extended Light'

    v.cmd [=[
        " Terminal ansi colors
        if !has('nvim')
            let g:terminal_ansi_colors =
            \ ['#000000',
            \ '#c72e0f',
            \ '#008000',
            \ '#FFAF00',
            \ '#007acc',
            \ '#af00db',
            \ '#56b6c2',
            \ '#000000',
            \ '#808080',
            \ '#c72e0f',
            \ '#008000',
            \ '#795e25',
            \ '#007acc',
            \ '#af00db',
            \ '#56b6c2',
            \ '#000000']
        else
            let g:terminal_color_0 = '#000000'
            let g:terminal_color_1 = '#c72e0f'
            let g:terminal_color_2 = '#008000'
            let g:terminal_color_3 = '#ffaf00'
            let g:terminal_color_4 = '#007acc'
            let g:terminal_color_5 = '#af00db'
            let g:terminal_color_6 = '#56b6c2'
            let g:terminal_color_7 = '#000000'
            let g:terminal_color_8 = '#808080'
            let g:terminal_color_9 = '#c72e0f'
            let g:terminal_color_10 = '#008000'
            let g:terminal_color_11 = '#795e25'
            let g:terminal_color_12 = '#007acc'
            let g:terminal_color_13 = '#af00db'
            let g:terminal_color_14 = '#56b6c2'
            let g:terminal_color_15 = '#000000'
        endif

        hi IndentBlanklineChar guifg=#bbbbbb gui=nocombine
    ]=]

    return true
end

return m
