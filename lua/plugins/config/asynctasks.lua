local m = {}
local v = require 'vim'
local user = require 'user'
local cmd = require 'vim.cmd'.silent

local input = v.fn.input
local system = v.fn.system

v.g.asyncrun_open = 6
v.g.asyncrun_rootmarks = user.settings.root_paths
v.g.asynctasks_term_pos = 'right'
v.g.asynctasks_term_rows = 10
v.g.asynctasks_term_cols = 80
v.g.asynctasks_term_reuse = 1

m.build_project = function()
    if #v.fn['asynctasks#list']('') == 0 then
        m.build_config()
    end
    cmd 'below copen'
    cmd 'wincmd p'
    cmd 'AsyncTask project-build'
end

m.run_project = function()
    if #v.fn['asynctasks#list']('') == 0 then
        m.build_config()
    end
    cmd 'AsyncTask project-run'
end

m.clean_project = function()
    if #v.fn['asynctasks#list']('') == 0 then
        m.build_config()
    end
    cmd 'below copen'
    cmd 'wincmd p'
    cmd 'AsyncTask project-clean'
end

m.build_config = function()
    local success, command = pcall(input, 'Build command: ')
    if not success then
        return
    end

    if #command ~= 0 then
        system("echo '[project-build]' > .tmptasks; echo -e 'command=" .. command .. "\nsave=2\n' >> .tmptasks")
    end

    success, command = pcall(input, 'Clean command: ')
    if not success then
        goto cleanup
    end

    if #command ~= 0 then
        system("echo '[project-clean]' >> .tmptasks; echo -e 'command=" .. command .. "\n' >> .tmptasks")
    end

    success, command = pcall(input, 'Run command: ')
    if not success then
        goto cleanup
    end

    if #command ~= 0 then
        system("echo '[project-run]' >> .tmptasks; echo -e 'command=" .. command .. "\n' >> .tmptasks; echo output=terminal >> .tmptasks")
    end

    system 'mv .tmptasks .tasks'

    ::cleanup::
    system 'rm -rf .tmptasks'
end

return m
