local m = {}
local v = require 'vim'
local user = require 'user'

v.g.asyncrun_open = 6
v.g.asyncrun_rootmarks = user.settings.root_paths
v.g.asynctasks_term_pos = 'right'
v.g.asynctasks_term_rows = 10
v.g.asynctasks_term_cols = 80
v.g.asynctasks_term_reuse = 1

v.cmd [=[

noremap <silent> <F7> :call ZBuildProject()<CR>
inoremap <silent> <F7> <esc>:call ZBuildProject()<CR>
if !has('nvim')
    noremap <silent> <C-F5> :call ZRunProject()<CR>
    inoremap <silent> <C-F5> <esc>:call ZRunProject()<CR>
    noremap <silent> <S-F7> :call ZCleanProject()<CR>
    inoremap <silent> <S-F7> <esc>:call ZCleanProject()<CR>
    noremap <silent> <C-F7> :call ZBuildConfig()<CR>
    inoremap <silent> <C-F7> <esc>:call ZBuildConfig()<CR>
else
    noremap <silent> <F29> :call ZRunProject()<CR>
    inoremap <silent> <F29> <esc>:call ZRunProject()<CR>
    noremap <silent> <F19> :call ZCleanProject()<CR>
    inoremap <silent> <F19> <esc>:call ZCleanProject()<CR>
    noremap <silent> <F31> :call ZBuildConfig()<CR>
    inoremap <silent> <F31> <esc>:call ZBuildConfig()<CR>
endif
function! ZBuildProject()
    if empty(asynctasks#list(""))
        call ZBuildConfig()
    endif
    below copen
    wincmd p
    AsyncTask project-build
endfunction
function! ZCleanProject()
    if empty(asynctasks#list(""))
        call ZBuildConfig()
    endif
    below copen
    wincmd p
    AsyncTask project-clean
endfunction
function! ZRunProject()
    if empty(asynctasks#list(""))
        call ZBuildConfig()
    endif
    AsyncTask project-run
endfunction
function! ZBuildConfig()
    call inputsave()
    let command = input('Build command: ')
    call inputrestore()
    normal :<ESC>
    if !empty(command)
        if filereadable(expand('~/.vim/.asynctasks_nosave'))
            call system("echo '[project-build]' > .tmptasks; echo -e 'command=" . command . "\n' >> .tmptasks")
        else
            call system("echo '[project-build]' > .tmptasks; echo -e 'command=" . command . "\n save=2 \n' >> .tmptasks")
        endif
    endif

    call inputsave()
    let command = input('Clean command: ')
    call inputrestore()
    normal :<ESC>
    if !empty(command)
        call system("echo '[project-clean]' >> .tmptasks; echo -e 'command=" . command . "\n' >> .tmptasks")
    endif

    call inputsave()
    let command = input('Run command: ')
    call inputrestore()
    normal :<ESC>
    if !empty(command)
        call system("echo '[project-run]' >> .tmptasks; echo -e 'command=" . command . "\n' >> .tmptasks; echo output=terminal >> .tmptasks")
    endif

    if filereadable('.tmptasks')
        call system("mv .tmptasks .tasks")
    endif
endfunction

]=]

return m
