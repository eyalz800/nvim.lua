local m = {}
local v = require 'vim'
local user = require 'user'

v.g.asyncrun_open = 6
v.g.asyncrun_rootmarks = user.settings.root_paths
v.g.asynctasks_term_pos = 'right'
v.g.asynctasks_term_rows = 10
v.g.asynctasks_term_cols = 80
v.g.asynctasks_term_reuse = 1

m.build_project = function()
    v.fn.Init_lua_build_project()
end

m.run_project = function()
    v.fn.Init_lua_run_project()
end

m.clean_project = function()
    v.fn.Init_lua_clean_project()
end

m.build_config = function()
    v.fn.Init_lua_build_config()
end

v.cmd [=[

function! Init_lua_build_project()
    if empty(asynctasks#list(""))
        call Init_lua_build_config()
    endif
    below copen
    wincmd p
    AsyncTask project-build
endfunction
function! Init_lua_clean_project()
    if empty(asynctasks#list(""))
        call Init_lua_build_config()
    endif
    below copen
    wincmd p
    AsyncTask project-clean
endfunction
function! Init_lua_run_project()
    if empty(asynctasks#list(""))
        call Init_lua_build_config()
    endif
    AsyncTask project-run
endfunction
function! Init_lua_build_config()
    call inputsave()
    let command = input('Build command: ')
    call inputrestore()
    normal :<esc>
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
    normal :<esc>
    if !empty(command)
        call system("echo '[project-clean]' >> .tmptasks; echo -e 'command=" . command . "\n' >> .tmptasks")
    endif

    call inputsave()
    let command = input('Run command: ')
    call inputrestore()
    normal :<esc>
    if !empty(command)
        call system("echo '[project-run]' >> .tmptasks; echo -e 'command=" . command . "\n' >> .tmptasks; echo output=terminal >> .tmptasks")
    endif

    if filereadable('.tmptasks')
        call system("mv .tmptasks .tasks")
    endif
endfunction

]=]

return m
