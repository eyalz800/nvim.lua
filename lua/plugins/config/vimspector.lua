local m = {}
local v = require 'vim'
local user = require 'user'

local file_readable = require 'vim.file_readable'.file_readable
local executable = require 'vim.executable'.executable
local feed_keys = require 'vim.feed_keys'.feed_keys

local map = v.keymap.set
local getline = v.fn.getline
local setline = v.fn.setline
local win_gotoid = v.fn.win_gotoid
local input = v.fn.input
local system = v.fn.system

m.launch_settings = function()
    local debug_type = v.bo.filetype
    if debug_type ~= 'cpp' and debug_type ~= 'c' and debug_type ~= 'python' then
        debug_type = input('Debugger type (cpp/python): ')
    end

    if debug_type == 'cpp' or debug_type == 'c' then
        m.generate_cpp_config()
    elseif debug_type == 'python' then
        m.generate_py_config()
    else
        error 'Invalid debug type!'
    end
end

m.launch = function()
    if not file_readable('.vimspector.json') then
        m.launch_settings()
    end

    if not file_readable('.vimspector.json') then
        return
    end

    v.fn['vimspector#Launch']()
end

m.continue = '<plug>VimspectorContinue'
m.restart = '<plug>VimspectorRestart'
m.pause = '<plug>VimspectorPause'
m.stop = '<plug>VimspectorStop'
m.breakpoint = '<plug>VimspectorToggleBreakpoint'
m.breakpoint_cond = '<plug>VimspectorToggleConditionalBreakpoint'
m.breakpoint_function = '<plug>VimspectorAddFunctionBreakpoint'
m.clear_breakpoints = v.fn['vimspector#ClearBreakpoints']
m.step_over = '<plug>VimspectorStepOver'
m.step_into = '<plug>VimspectorStepInto'
m.step_out = '<plug>VimspectorStepOut'
m.run_to_cursor = '<plug>VimspectorRunToCursor'
m.disassemble = '<plug>VimspectorDisassemble'
m.eval_window = '<plug>VimspectorBalloonEval'
m.reset = v.fn['vimspector#Reset']

m.on_winbar_stop = function() v.fn['vimspector#Stop']() end
m.on_winbar_continue = function() v.fn['vimspector#Continue']() end
m.on_winbar_pause = function() v.fn['vimspector#Pause']() end
m.on_winbar_step_over = function() v.fn['vimspector#StepOver']() end
m.on_winbar_step_into = function() v.fn['vimspector#StepInto']() end
m.on_winbar_step_out = function() v.fn['vimspector#StepOut']() end
m.on_winbar_restart = function() v.fn['vimspector#Restart']() end
m.on_winbar_exit = function() v.fn['vimspector#Reset']() end

m.toggle_breakpoint = v.fn['vimspector#ToggleBreakpoint']
m.reset_ui = function() end
m.toggle_ui = function() end

v.g.vimspector_install_gadgets = {'debugpy', 'CodeLLDB', 'vscode-cpptools'}
v.g.vimspector_sign_priority = {
    vimspectorBP = 300,
    vimspectorBPCond = 200,
    vimspectorBPDisabled = 100,
    vimspectorPC = 999,
    vimspectorPCBP = 999,
}

m.on_initialize_prompt = function()
    map('n', 'x', 'i-exec<space>', {silent=true, buffer=true})

    if not v.b.vimspector_command_history then
        v.b.vimspector_command_history = {}
        v.b.vimspector_command_history_pos = 0
        m.command_history_initialize()
    end
end

m.on_ui_created = function()
    win_gotoid(v.g.vimspector_session_windows.output)
    v.bo.filetype='asm'
    win_gotoid(v.g.vimspector_session_windows.code)
    v.cmd [=[
        split
        resize -1000
        enew
    ]=]
    v.bo.filetype = 'VimspectorPrompt'
    v.bo.buftype = 'prompt'
    v.bo.modifiable = false
    v.bo.textwidth = 0
    v.opt_local.cursorline = false
    v.opt_local.number = false
    v.opt_local.winbar = [=[%#ToolbarButton#%0@v:lua.require'plugins.config.vimspector'.on_winbar_stop@ ■ Stop %X%*]=] ..
                         [=[  %#ToolbarButton#%1@v:lua.require'plugins.config.vimspector'.on_winbar_continue@ ▶ Cont %X%*]=] ..
                         [=[  %#ToolbarButton#%2@v:lua.require'plugins.config.vimspector'.on_winbar_pause@ 󰏤 Pause %X%*]=] ..
                         [=[  %#ToolbarButton#%3@v:lua.require'plugins.config.vimspector'.on_winbar_step_over@ ↷ Next %X%*]=] ..
                         [=[  %#ToolbarButton#%4@v:lua.require'plugins.config.vimspector'.on_winbar_step_into@ → Step %X%*]=] ..
                         [=[  %#ToolbarButton#%5@v:lua.require'plugins.config.vimspector'.on_winbar_step_out@ ← Out %X%*]=] ..
                         [=[  %#ToolbarButton#%6@v:lua.require'plugins.config.vimspector'.on_winbar_restart@ ↺ %X%*]=] ..
                         [=[  %#ToolbarButton#%7@v:lua.require'plugins.config.vimspector'.on_winbar_exit@ ✕ %X%*]=]
    win_gotoid(v.g.vimspector_session_windows.code)
end

m.command_history_initialize = function()
    map('i', '<cr>', m.command_history_add, {silent=true, buffer=true, expr=true})
    map('i', '<up>', m.command_history_up, {silent=true, buffer=true})
    map('i', '<down>', m.command_history_down, {silent=true, buffer=true})
end

m.command_history_add = function()
    local history = v.b.vimspector_command_history
    table.insert(history, getline('.'))
    v.b.vimspector_command_history = history
    v.b.vimspector_command_history_pos = #v.b.vimspector_command_history
    return '<cr>'
end

m.command_history_up = function()
    if #v.b.vimspector_command_history == 0 or v.b.vimspector_command_history_pos == 0 then
        return
    end

    setline('.', v.b.vimspector_command_history[v.b.vimspector_command_history_pos])
    if v.b.vimspector_command_history_pos ~= 1 then
        v.b.vimspector_command_history_pos = v.b.vimspector_command_history_pos - 1
    end
    feed_keys '<c-o>A'
end

m.command_history_down = function()
    if #v.b.vimspector_command_history == v.b.vimspector_command_history_pos then
        setline('.', '> ')
    else
        v.b.vimspector_command_history_pos = v.b.vimspector_command_history_pos + 1
        setline('.', v.b.vimspector_command_history[v.b.vimspector_command_history_pos])
    end
    feed_keys '<c-o>A'
end

m.on_visual_multi_exit = function()
    if v.bo.filetype == 'VimspectorPrompt' then
        m.command_history_initialize()
    end
end

v.cmd [=[
    hi! def link InitLuaDebugBP WarningMsg
    hi! def link InitLuaDebugBPDisabled LineNr
    hi! def link InitLuaDebugPC  String
    sign define vimspectorBP            text= texthl=InitLuaDebugBP
    sign define vimspectorBPCond        text= texthl=InitLuaDebugBP
    sign define vimspectorBPLog         text=󰛿 texthl=InitLuaDebugBP
    sign define vimspectorBPDisabled    text= texthl=InitLuaDebugBPDisabled
    sign define vimspectorPC            text= texthl=InitLuaDebugPC  linehl=CursorLine
    sign define vimspectorPCBP          text= texthl=InitLuaDebugPC  linehl=CursorLine
]=]

m.generate_cpp_config = function()
    local target = input('Target (Executable/IP): ')

    local debugger = 'gdb'
    if not executable 'gdb' and executable 'lldb' then
        debugger = 'lldb'
    end

    if user.settings.native_debugger_plugin == 'vscode-cpptools' then
        if string.find(target, ':', 1, true) and not v.loop.fs_stat(target) then
            local main_file = input 'Main File: '
            system(
                "echo '{' > .vimspector.json &&" ..
                "echo '    \"configurations\": {' >> .vimspector.json &&" ..
                "echo '        \"Launch\": {' >> .vimspector.json &&" ..
                "echo '            \"adapter\": \"vscode-cpptools\",' >> .vimspector.json &&" ..
                "echo '            \"configuration\": {' >> .vimspector.json &&" ..
                "echo '                \"request\": \"launch\",' >> .vimspector.json &&" ..
                "echo '                \"program\": \"" .. main_file .. "\",' >> .vimspector.json &&" ..
                "echo '                \"cwd\": \"${workspaceRoot}\",' >> .vimspector.json &&" ..
                "echo '                \"type\": \"cppdbg\",' >> .vimspector.json &&" ..
                "echo '                \"setupCommands\": [' >> .vimspector.json &&" ..
                "echo '                    { \"text\": \"set disassembly-flavor intel\", \"description\": \"\", \"ignoreFailures\": false },' >> .vimspector.json &&" ..
                "echo '                    { \"text\": \"-enable-pretty-printing\", \"description\": \"\", \"ignoreFailures\": false }' >> .vimspector.json &&" ..
                "echo '                ],' >> .vimspector.json &&" ..
                "echo '                \"miDebuggerServerAddress\": \"" .. target .. "\",' >> .vimspector.json &&" ..
                "echo '                \"externalConsole\": true,' >> .vimspector.json &&" ..
                "echo '                \"stopAtEntry\": true,' >> .vimspector.json &&" ..
                "echo '                \"miDebuggerPath\": \"" .. debugger .. "\",' >> .vimspector.json &&" ..
                "echo '                \"MIMode\": \"" .. debugger .. "\"' >> .vimspector.json &&" ..
                "echo '            }' >> .vimspector.json &&" ..
                "echo '        }' >> .vimspector.json &&" ..
                "echo '    }' >> .vimspector.json &&" ..
                "echo '}' >> .vimspector.json"
            )
        else
            system(
                "echo '{' > .vimspector.json && " ..
                "echo '    \"configurations\": {' >> .vimspector.json && " ..
                "echo '        \"Launch\": {' >> .vimspector.json && " ..
                "echo '            \"adapter\": \"vscode-cpptools\",' >> .vimspector.json && " ..
                "echo '            \"configuration\": {' >> .vimspector.json && " ..
                "echo '                \"request\": \"launch\",' >> .vimspector.json && " ..
                "echo '                \"type\": \"cppdbg\",' >> .vimspector.json && " ..
                "echo '                \"program\": \"" .. target .. "\",' >> .vimspector.json && " ..
                "echo '                \"args\": [],' >> .vimspector.json && " ..
                "echo '                \"environment\": [],' >> .vimspector.json && " ..
                "echo '                \"cwd\": \"${workspaceRoot}\",' >> .vimspector.json && " ..
                "echo '                \"externalConsole\": true,' >> .vimspector.json && " ..
                "echo '                \"stopAtEntry\": true,' >> .vimspector.json && " ..
                "echo '                \"setupCommands\": [' >> .vimspector.json && " ..
                "echo '                    { \"text\": \"set disassembly-flavor intel\", \"description\": \"\", \"ignoreFailures\": false },' >> .vimspector.json && " ..
                "echo '                    { \"text\": \"-enable-pretty-printing\", \"description\": \"\", \"ignoreFailures\": false }' >> .vimspector.json && " ..
                "echo '                ],' >> .vimspector.json && " ..
                "echo '                \"MIMode\": \"" .. debugger .. "\"' >> .vimspector.json && " ..
                "echo '            }' >> .vimspector.json && " ..
                "echo '        }' >> .vimspector.json && " ..
                "echo '    }' >> .vimspector.json && " ..
                "echo '}' >> .vimspector.json"
            )
        end
    else
        if string.find(target, ':', 1, true) and not v.loop.fs_stat(target) then
            local main_file = input 'Main File: '
            system(
                "echo '{' > .vimspector.json && " ..
                "echo '    \"configurations\": {' >> .vimspector.json && " ..
                "echo '        \"Launch\": {' >> .vimspector.json && " ..
                "echo '            \"adapter\": \"CodeLLDB\",' >> .vimspector.json && " ..
                "echo '            \"configuration\": {' >> .vimspector.json && " ..
                "echo '                \"name\": \"remote attach\",' >> .vimspector.json && " ..
                "echo '                \"request\": \"launch\",' >> .vimspector.json && " ..
                "echo '                \"custom\": true,' >> .vimspector.json && " ..
                "echo '                \"type\": \"" .. debugger .. "\",' >> .vimspector.json && " ..
                "echo '                \"targetCreateCommands\": [\"target create " .. main_file .. "\"],' >> .vimspector.json && " ..
                "echo '                \"processCreateCommands\": [\"gdb-remote " .. target .. "\"],' >> .vimspector.json && " ..
                "echo '                \"args\": [],' >> .vimspector.json && " ..
                "echo '                \"environment\": [],' >> .vimspector.json && " ..
                "echo '                \"cwd\": \"${workspaceRoot}\",' >> .vimspector.json && " ..
                "echo '                \"terminal\": \"external\",' >> .vimspector.json && " ..
                "echo '                \"stopOnEntry\": true,' >> .vimspector.json && " ..
                "echo '                \"sourceMap\": {' >> .vimspector.json && " ..
                "echo '                    \"\": \"\"' >> .vimspector.json && " ..
                "echo '                },' >> .vimspector.json && " ..
                "echo '                \"initCommands\": [' >> .vimspector.json && " ..
                "echo '                    \"settings set target.x86-disassembly-flavor intel\"' >> .vimspector.json && " ..
                "echo '                ]' >> .vimspector.json && " ..
                "echo '            },' >> .vimspector.json && " ..
                "echo '            \"breakpoints\": {' >> .vimspector.json && " ..
                "echo '                \"exception\": {' >> .vimspector.json && " ..
                "echo '                    \"cpp_throw\": \"N\",' >> .vimspector.json && " ..
                "echo '                    \"cpp_catch\": \"N\"' >> .vimspector.json && " ..
                "echo '                }' >> .vimspector.json && " ..
                "echo '            }' >> .vimspector.json && " ..
                "echo '        }' >> .vimspector.json && " ..
                "echo '    }' >> .vimspector.json && " ..
                "echo '}' >> .vimspector.json"
            )
        else
            system(
                "echo '{' > .vimspector.json && " ..
                "echo '    \"configurations\": {' >> .vimspector.json && " ..
                "echo '        \"Launch\": {' >> .vimspector.json && " ..
                "echo '            \"adapter\": \"CodeLLDB\",' >> .vimspector.json && " ..
                "echo '            \"configuration\": {' >> .vimspector.json && " ..
                "echo '                \"name\": \"launch\",' >> .vimspector.json && " ..
                "echo '                \"request\": \"launch\",' >> .vimspector.json && " ..
                "echo '                \"type\": \"" .. debugger .. "\",' >> .vimspector.json && " ..
                "echo '                \"program\": \"" .. target .. "\",' >> .vimspector.json && " ..
                "echo '                \"args\": [],' >> .vimspector.json && " ..
                "echo '                \"environment\": [],' >> .vimspector.json && " ..
                "echo '                \"cwd\": \"${workspaceRoot}\",' >> .vimspector.json && " ..
                "echo '                \"terminal\": \"external\",' >> .vimspector.json && " ..
                "echo '                \"stopOnEntry\": true,' >> .vimspector.json && " ..
                "echo '                \"initCommands\": [' >> .vimspector.json && " ..
                "echo '                    \"settings set target.x86-disassembly-flavor intel\"' >> .vimspector.json && " ..
                "echo '                ]' >> .vimspector.json && " ..
                "echo '            },' >> .vimspector.json && " ..
                "echo '            \"breakpoints\": {' >> .vimspector.json && " ..
                "echo '                \"exception\": {' >> .vimspector.json && " ..
                "echo '                    \"cpp_throw\": \"N\",' >> .vimspector.json && " ..
                "echo '                    \"cpp_catch\": \"N\"' >> .vimspector.json && " ..
                "echo '                }' >> .vimspector.json && " ..
                "echo '            }' >> .vimspector.json && " ..
                "echo '        }' >> .vimspector.json && " ..
                "echo '    }' >> .vimspector.json && " ..
                "echo '}' >> .vimspector.json"
            )
        end
    end
end

m.generate_py_config = function()
    local program = input('Python main file: ')
    local python = 'python3'
    system(
        "echo '{' > .vimspector.json && " ..
        "echo '    \"configurations\": {' >> .vimspector.json && " ..
        "echo '        \"Launch\": {' >> .vimspector.json && " ..
        "echo '            \"adapter\": \"debugpy\",' >> .vimspector.json && " ..
        "echo '            \"breakpoints\": {\"exception\": {\"raised\": \"N\", \"uncaught\": \"Y\"}},' >> .vimspector.json && " ..
        "echo '            \"configuration\": {' >> .vimspector.json && " ..
        "echo '                \"request\": \"launch\",' >> .vimspector.json && " ..
        "echo '                \"type\": \"python\",' >> .vimspector.json && " ..
        "echo '                \"program\": \"" .. program .. "\",' >> .vimspector.json && " ..
        "echo '                \"args\": [],' >> .vimspector.json && " ..
        "echo '                \"python\": \"" .. python .. "\",' >> .vimspector.json && " ..
        "echo '                \"cwd\": \"${workspaceRoot}\",' >> .vimspector.json && " ..
        "echo '                \"externalConsole\": true,' >> .vimspector.json && " ..
        "echo '                \"stopAtEntry\": true' >> .vimspector.json && " ..
        "echo '            }' >> .vimspector.json && " ..
        "echo '        }' >> .vimspector.json && " ..
        "echo '    }' >> .vimspector.json && " ..
        "echo '}' >> .vimspector.json"
    )
end

return m
