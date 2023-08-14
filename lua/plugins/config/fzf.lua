local m = {}
local v = require 'vim'
local sed = require 'lib.os_bin'.sed
local cmd = require 'vim.cmd'.silent

v.g.fzf_layout = { window={width=0.9, height=0.85, border='sharp'} }

m.find_file = function()
    v.env.FZF_DEFAULT_COMMAND = 'rg --files'
    cmd 'Files'
end

m.find_file_hidden = function()
    v.env.FZF_DEFAULT_COMMAND = 'rg --files --no-ignore-vcs --hidden'
    cmd 'Files'
end

m.find_in_files = function()
    cmd 'Rg'
end

m.find_line = function()
    v.fn.Init_lua_lines_preview()
end

m.find_content_in_files = function()
    v.fn.Init_lua_rg(false)
end

m.find_folder = function()
    v.fn.Init_lua_find_folder()
end

v.cmd([=[

set rtp+=~/.fzf
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'SpecialKey'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'String'],
  \ 'info':    ['fg', 'Comment'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'StorageClass'],
  \ 'pointer': ['fg', 'Error'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

function! Init_lua_lines_preview()
    if !exists('*fzf#vim#grep')
        call plug#load('fzf.vim')
    endif
    if !filereadable(expand('%')) || (exists('b:objdump_view') && b:objdump_view) || (exists('b:binary_mode') && b:binary_mode)
        BLines
    else
        call fzf#vim#grep(
            \ 'rg --with-filename --column --line-number --no-heading --smart-case . '.fnameescape(expand('%:p')), 1,
            \ fzf#vim#with_preview({'options': '--keep-right --delimiter : --nth 4.. --preview "bat -p --color always {}"'
            \ . ' --bind "ctrl-/:toggle-preview"'}, 'right:50%' ))
    endif
endfunction

function! Init_lua_rg(fullscreen)
    let initial_command = 'rg --column --line-number --no-heading --color=always --smart-case . '
    let reload_command = 'echo {q} | ]=] .. sed .. [=[ "s/^\(type:\)\([A-Za-z0-9]*\) */-t \2 /g"'
                \ . ' | ]=] .. sed .. [=[ "s/^\(pattern:\)\([A-Za-z0-9*.]*\) */-g \"\2\" /g"'
                \ . ' | ]=] .. sed .. [=[ "s/^\(-[gt] *[A-Za-z0-9*.\"]* \)\\?\(.*\)/\1\"\2\"/g"'
                \ . ' | xargs rg --column --line-number --no-heading --color=always --smart-case || true'
    let spec = {'options': ['--phony', '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

function! Init_lua_find_folder()
    function! s:sink(result)
        exec 'cd ' . system('dirname ' . a:result)
    endfunction

    let fzf_color_option = split(fzf#wrap()['options'])[0]
    let preview = "ls -la --color \\$(dirname {})"
    let opts = { 'options': fzf_color_option . ' --prompt "> "' .
                \ ' --preview="' . preview . '"' .
                \ ' --bind "ctrl-/:toggle-preview"',
                \ 'sink': function('s:sink')}

    let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --no-ignore-vcs'
    call fzf#run(fzf#wrap('', opts, 0))
endfunction

]=])

return m
