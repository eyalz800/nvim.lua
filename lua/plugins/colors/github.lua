local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent
local user = require 'user'

m.apply = function()
    if v.o.background == 'dark' then
        v.opt.background = 'light'
        v.schedule(function() cmd 'color github' end)
        return false
    end

    v.env.BAT_THEME = 'Monokai Extended Light'

    v.cmd [=[
        " Terminal ansi colors
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

        hi IndentBlanklineChar guifg=#bbbbbb gui=nocombine

        function! Init_lua_github_airline_theme_patch(palette)
            if g:airline_theme != 'github'
                return
            endif

            let airline_insert_1 = ['#ffffff', '#ef5939', '0', '0']
            let airline_insert_2 = ['#dddddd', '#404040', '0', '0']
            let airline_insert_3 = ['#000000', '#dddddd', '0', '0']
            let a:palette.insert = airline#themes#generate_color_map(airline_insert_1, airline_insert_2, airline_insert_3)

            let airline_visual_1 = ['#ffffff', '#159828', '0', '0']
            let airline_visual_2 = ['#dddddd', '#404040', '0', '0']
            let airline_visual_3 = ['#000000', '#dddddd', '0', '0']
            let a:palette.visual = airline#themes#generate_color_map(airline_visual_1, airline_visual_2, airline_visual_3)
        endfunction
    ]=]

    if user.settings.finder == 'fzf' or user.settings.finder == 'fzf-lua' then
        v.g.fzf_colors = {
            fg = { 'fg', 'Normal' },
            bg = { 'bg', 'Normal' },
            hl = { 'fg', 'SpecialKey' },
            ['fg+'] = { 'fg', 'CursorLine' },
            ['bg+'] = { 'bg', 'CursorLine' },
            ['hl+'] = { 'fg', 'String' },
            info = { 'fg', 'Comment' },
            border = { 'fg', 'CursorLine' },
            prompt = { 'fg', 'StorageClass' },
            pointer = { 'fg', 'Error' },
            marker = { 'fg', 'Keyword' },
            spinner = { 'fg', 'Label' },
            header = { 'fg', 'Comment' }
        }
    end

    if user.settings.line == 'airline' then
        v.g.airline_theme_patch_func = 'Init_lua_github_airline_theme_patch'
    end

    return true
end

return m
