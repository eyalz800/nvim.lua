local m = {}
local v = require 'vim'
local user = require 'user'
local cmd = require 'vim.cmd'.silent
local quickfix = require 'plugins.quickfix'

local input = v.fn.input
local system = v.fn.system

v.g.asyncrun_open = 0
v.g.asyncrun_rootmarks = user.settings.root_paths
v.g.asynctasks_term_pos = 'floaterm'

m.build_project = function()
    if #v.fn['asynctasks#list']('') == 0 then
        if not m.build_config() then
            return
        end
    end
    quickfix.open({ focus = false, expand = true })
    cmd 'AsyncTask project-build'
end

m.run_project = function()
    if #v.fn['asynctasks#list']('') == 0 then
        if not m.build_config() then
            return
        end
    end
    cmd 'AsyncTask project-run'
end

m.clean_project = function()
    if #v.fn['asynctasks#list']('') == 0 then
        m.build_config()
    end
    quickfix.open({ focus = false, expand = true })
    cmd 'AsyncTask project-clean'
end

m.build_config = function()
    local success, command = pcall(input, 'Build command: ', '', 'shellcmd')
    if not success then
        return false
    end

    if #command ~= 0 then
        system("echo '[project-build]' > .tmptasks; echo -e 'command=" .. command .. "\nsave=2\n' >> .tmptasks")
    end

    success, command = pcall(input, 'Clean command: ', '', 'shellcmd')
    if not success then
        goto cleanup
    end

    if #command ~= 0 then
        system("echo '[project-clean]' >> .tmptasks; echo -e 'command=" .. command .. "\n' >> .tmptasks")
    end

    success, command = pcall(input, 'Run command: ', '', 'shellcmd')
    if not success then
        goto cleanup
    end

    if #command ~= 0 then
        system("echo '[project-run]' >> .tmptasks; echo -e 'command=" .. command .. "\n' >> .tmptasks; echo output=terminal >> .tmptasks")
    end

    system 'mv .tmptasks .tasks'

    ::cleanup::
    system 'rm -rf .tmptasks'

    return success
end

return m
