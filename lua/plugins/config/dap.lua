local m = {}
local v = require 'vim'

local ui = require 'plugins.config.dap-ui'

local fs_stat = v.loop.fs_stat
local input = v.fn.input
local system = v.fn.system
local inspect = v.inspect
local getcwd = v.fn.getcwd

local dap = nil
local sign_define = v.fn.sign_define

local translation = {
    codelldb = { 'c', 'cpp' },
    cppdbg = { 'c', 'cpp' },
}

m.launch_settings = function()
    local debug_type = v.bo.filetype
    local success = nil

    if not dap.configurations[debug_type] then
        success, debug_type = pcall(input, 'Debugger type: ', 'cpp')
        if not success then
            return
        end
    end

    if not dap.configurations[debug_type] then
        error('Invalid debug type, current configuration: ' .. inspect(dap.configurations))
    end

    if debug_type == 'cpp' or debug_type == 'c' then
        m.generate_cpp_config()
    elseif debug_type == 'python' then
        m.generate_py_config()
    end

    m.launch({ debug_type = debug_type })
end

m.launch = function(options)
    local debug_type = (options or {}).debug_type or v.bo.filetype
    local success = nil

    if not dap.configurations[debug_type] then
        success, debug_type = pcall(input, 'Debugger type: ', 'cpp')
        if not success then
            return
        end
    end

    if not dap.configurations[debug_type] then
        error('Invalid debug type, current configuration: ' .. require 'vim.echo'.inspect(dap.configurations))
        return
    end

    if dap.session() then
        dap.disconnect()
    end

    if fs_stat 'launch.json' then
        require 'dap.ext.vscode'.load_launchjs('launch.json', translation)
        dap.run(dap.configurations[debug_type][#dap.configurations[debug_type]], {})
        return
    end

    dap.continue()
end

m.continue = function()
    if not dap.session() then
        return m.launch()
    end
    return dap.continue()
end

m.restart = function() return dap.restart() end
m.pause = function() return dap.pause() end
m.stop = function() return dap.stop() end
m.breakpoint = function() return dap.toggle_breakpoint() end
m.breakpoint_cond = function() end
m.breakpoint_function = function() end
m.clear_breakpoints = function() return dap.clear_breakpoints() end
m.step_over = function() return dap.step_over() end

m.step_into = function() return dap.step_into() end
m.step_out = function() return dap.step_out() end
m.run_to_cursor = function() return dap.run_to_cursor() end
m.disassemble = function() end
m.eval_window = function() end
m.reset = function()
    if dap.session() then
        dap.disconnect()
    end
    ui.close()
end
m.toggle_breakpoint = function() return dap.toggle_breakpoint() end
m.reset_ui = function()
    ui.dapui.open({ reset = true })
end
m.toggle_ui = function()
    ui.dapui.toggle({ reset = true })
end
m.on_dap_repl_attach = function()
    require 'dap.ext.autocompl'.attach()
end

v.cmd [=[
    hi! def link InitLuaDebugBP WarningMsg
    hi! def link InitLuaDebugBPDisabled LineNr
    hi! def link InitLuaDebugPC  String
]=]

m.config = function()
    dap = require 'dap'
    sign_define('DapBreakpoint', { text='', texthl='InitLuaDebugBP' })
    sign_define('DapBreakpointCondition', { text='', texthl='InitLuaDebugBP' })
    sign_define('DapLogPoint', { text='󰛿', texthl='InitLuaDebugBP' })
    sign_define('DapBreakpointRejected', { text='', texthl='InitLuaDebugBPDisabled' })
    sign_define('DapStopped', { text='', texthl='InitLuaDebugPC', linehl='CursorLine' })

    return {}
end

m.generate_cpp_config = function()
    local target = input('(launch.json) target: ', getcwd() .. '/', 'file')
    local type = input('(launch.json) type: ', 'codelldb/cppdbg')

    if type == 'codelldb' then
        if string.find(target, ':', 1, true) and not v.loop.fs_stat(target) then
            local main_file = input('(attach) main file: ', getcwd() .. '/', 'file')
            system(
                "echo '{' > launch.json && " ..
                "echo '    \"configurations\": [' >> launch.json && " ..
                "echo '        {' >> launch.json && " ..
                "echo '            \"name\": \"remote attach (codelldb)\",' >> launch.json && " ..
                "echo '            \"request\": \"launch\",' >> launch.json && " ..
                "echo '            \"custom\": true,' >> launch.json && " ..
                "echo '            \"type\": \"codelldb\",' >> launch.json && " ..
                "echo '            \"targetCreateCommands\": [\"target create " .. main_file .. "\"],' >> launch.json && " ..
                "echo '            \"processCreateCommands\": [\"gdb-remote " .. target .. "\"],' >> launch.json && " ..
                "echo '            \"args\": [],' >> launch.json && " ..
                "echo '            \"environment\": [],' >> launch.json && " ..
                "echo '            \"cwd\": \"${workspaceFolder}\",' >> launch.json && " ..
                "echo '            \"stopOnEntry\": true,' >> launch.json && " ..
                "echo '            \"sourceMap\": {' >> launch.json && " ..
                "echo '                \"\": \"\"' >> launch.json && " ..
                "echo '            },' >> launch.json && " ..
                "echo '            \"initCommands\": [' >> launch.json && " ..
                "echo '                \"settings set target.x86-disassembly-flavor intel\"' >> launch.json && " ..
                "echo '            ]' >> launch.json && " ..
                "echo '        }' >> launch.json && " ..
                "echo '    ]' >> launch.json && " ..
                "echo '}' >> launch.json"
            )
        else
            system(
                "echo '{' > launch.json && " ..
                "echo '    \"configurations\": [' >> launch.json && " ..
                "echo '        {' >> launch.json && " ..
                "echo '            \"name\": \"local launch (codelldb)\",' >> launch.json && " ..
                "echo '            \"request\": \"launch\",' >> launch.json && " ..
                "echo '            \"type\": \"codelldb\",' >> launch.json && " ..
                "echo '            \"program\": \"" .. target .. "\",' >> launch.json && " ..
                "echo '            \"args\": [],' >> launch.json && " ..
                "echo '            \"environment\": [],' >> launch.json && " ..
                "echo '            \"cwd\": \"${workspaceFolder}\",' >> launch.json && " ..
                "echo '            \"stopOnEntry\": true,' >> launch.json && " ..
                "echo '            \"initCommands\": [' >> launch.json && " ..
                "echo '                \"settings set target.x86-disassembly-flavor intel\"' >> launch.json && " ..
                "echo '            ]' >> launch.json && " ..
                "echo '        }' >> launch.json && " ..
                "echo '    ]' >> launch.json && " ..
                "echo '}' >> launch.json"
            )
        end
    elseif type == 'cppdbg' then
        if string.find(target, ':', 1, true) and not v.loop.fs_stat(target) then
            local main_file = input('(attach) main file: ', getcwd() .. '/', 'file')
            system(
                "echo '{' > launch.json && " ..
                "echo '    \"configurations\": [' >> launch.json &&" ..
                "echo '        {' >> launch.json && " ..
                "echo '            \"name\": \"remote attach (cppdbg)\",' >> launch.json && " ..
                "echo '            \"request\": \"launch\",' >> launch.json && " ..
                "echo '            \"program\": \"" .. main_file .. "\",' >> launch.json && " ..
                "echo '            \"cwd\": \"${workspaceFolder}\",' >> launch.json && " ..
                "echo '            \"type\": \"cppdbg\",' >> launch.json && " ..
                "echo '            \"args\": [],' >> launch.json && " ..
                "echo '            \"environment\": [],' >> launch.json && " ..
                "echo '            \"setupCommands\": [' >> launch.json && " ..
                "echo '                { \"text\": \"set disassembly-flavor intel\", \"description\": \"\", \"ignoreFailures\": false },' >> launch.json && " ..
                "echo '                { \"text\": \"-enable-pretty-printing\", \"description\": \"\", \"ignoreFailures\": false }' >> launch.json && " ..
                "echo '            ],' >> launch.json && " ..
                "echo '            \"stopAtEntry\": true,' >> launch.json && " ..
                "echo '            \"miDebuggerServerAddress\": \"" .. target .. "\",' >> launch.json && " ..
                "echo '            \"miDebuggerPath\": \"gdb\",' >> launch.json &&" ..
                "echo '            \"MIMode\": \"gdb\"' >> launch.json &&" ..
                "echo '        }' >> launch.json && " ..
                "echo '    ]' >> launch.json && " ..
                "echo '}' >> launch.json"
            )
        else
            system(
                "echo '{' > launch.json && " ..
                "echo '    \"configurations\": [' >> launch.json && " ..
                "echo '        {' >> launch.json && " ..
                "echo '            \"name\": \"local launch (cppdbg)\",' >> launch.json && " ..
                "echo '            \"request\": \"launch\",' >> launch.json && " ..
                "echo '            \"program\": \"" .. target .. "\",' >> launch.json && " ..
                "echo '            \"cwd\": \"${workspaceFolder}\",' >> launch.json && " ..
                "echo '            \"type\": \"cppdbg\",' >> launch.json && " ..
                "echo '            \"args\": [],' >> launch.json && " ..
                "echo '            \"environment\": [],' >> launch.json && " ..
                "echo '            \"setupCommands\": [' >> launch.json && " ..
                "echo '                { \"text\": \"set disassembly-flavor intel\", \"description\": \"\", \"ignoreFailures\": false },' >> launch.json && " ..
                "echo '                { \"text\": \"-enable-pretty-printing\", \"description\": \"\", \"ignoreFailures\": false }' >> launch.json && " ..
                "echo '            ],' >> launch.json && " ..
                "echo '            \"stopAtEntry\": true,' >> launch.json && " ..
                "echo '            \"miDebuggerPath\": \"gdb\",' >> launch.json &&" ..
                "echo '            \"MIMode\": \"gdb\"' >> launch.json &&" ..
                "echo '        }' >> launch.json && " ..
                "echo '    ]' >> launch.json && " ..
                "echo '}' >> launch.json"
            )
        end
    else
        error 'Invalid choice!'
    end
end

m.generate_py_config = function()
    local program = input('(launch.json) target: ', getcwd() .. '/', 'file')
    local python = 'python3'
    system(
        "echo '{' > launch.json && " ..
        "echo '    \"configurations\": [' >> launch.json && " ..
        "echo '        {' >> launch.json && " ..
        "echo '            \"name\": \"launch\",' >> launch.json && " ..
        "echo '            \"request\": \"launch\",' >> launch.json && " ..
        "echo '            \"type\": \"python\",' >> launch.json && " ..
        "echo '            \"program\": \"" .. program .. "\",' >> launch.json && " ..
        "echo '            \"args\": [],' >> launch.json && " ..
        "echo '            \"python\": \"" .. python .. "\",' >> launch.json && " ..
        "echo '            \"cwd\": \"${workspaceFolder}\",' >> launch.json && " ..
        "echo '            \"stopOnEntry\": true' >> launch.json && " ..
        "echo '        }' >> launch.json && " ..
        "echo '    ]' >> launch.json && " ..
        "echo '}' >> launch.json"
    )
end

return m
