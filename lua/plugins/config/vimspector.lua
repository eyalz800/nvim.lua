local m = {}
local user = require 'user'

local file_readable = require 'vim.file-readable'.file_readable
local executable = require 'vim.executable'.executable
local feed_keys = require 'vim.feed-keys'.feed_keys

local map = vim.keymap.set
local getline = vim.fn.getline
local setline = vim.fn.setline
local win_gotoid = vim.fn.win_gotoid
local input = vim.fn.input
local system = vim.fn.system

m.setup = function()
    vim.api.nvim_create_autocmd('filetype', {
        pattern = 'VimspectorPrompt',
        group = vim.api.nvim_create_augroup('init.lua.vimspector.prompt', {}),
        callback = require 'plugins.config.vimspector'.on_initialize_prompt
    })

    vim.api.nvim_create_autocmd('User', {
        pattern = 'VimspectorUICreated',
        group = vim.api.nvim_create_augroup('init.lua.vimspector.ui-created', {}),
        callback = require 'plugins.config.vimspector'.on_ui_created
    })

    vim.api.nvim_create_autocmd('User', {
        pattern = 'visual_multi_exit',
        group = vim.api.nvim_create_augroup('init.lua.vimspector.visual-multi-exit', {}),
        callback = require 'plugins.config.vimspector'.on_visual_multi_exit
    })
end

m.launch_settings = function()
    local debug_type = vim.bo.filetype
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

    vim.fn['vimspector#Launch']()
end

m.continue = '<plug>VimspectorContinue'
m.restart = '<plug>VimspectorRestart'
m.pause = '<plug>VimspectorPause'
m.stop = '<plug>VimspectorStop'
m.breakpoint = '<plug>VimspectorToggleBreakpoint'
m.breakpoint_cond = '<plug>VimspectorToggleConditionalBreakpoint'
m.breakpoint_function = '<plug>VimspectorAddFunctionBreakpoint'
m.clear_breakpoints = vim.fn['vimspector#ClearBreakpoints']
m.step_over = '<plug>VimspectorStepOver'
m.step_into = '<plug>VimspectorStepInto'
m.step_out = '<plug>VimspectorStepOut'
m.run_to_cursor = '<plug>VimspectorRunToCursor'
m.disassemble = '<plug>VimspectorDisassemble'
m.eval_window = '<plug>VimspectorBalloonEval'
m.reset = vim.fn['vimspector#Reset']

m.on_winbar_stop = function() vim.fn['vimspector#Stop']() end
m.on_winbar_continue = function() vim.fn['vimspector#Continue']() end
m.on_winbar_pause = function() vim.fn['vimspector#Pause']() end
m.on_winbar_step_over = function() vim.fn['vimspector#StepOver']() end
m.on_winbar_step_into = function() vim.fn['vimspector#StepInto']() end
m.on_winbar_step_out = function() vim.fn['vimspector#StepOut']() end
m.on_winbar_restart = function() vim.fn['vimspector#Restart']() end
m.on_winbar_exit = function() vim.fn['vimspector#Reset']() end

m.toggle_breakpoint = vim.fn['vimspector#ToggleBreakpoint']
m.reset_ui = function() end
m.toggle_ui = function() end
m.is_ui_open = function() end

vim.g.vimspector_install_gadgets = {'debugpy', 'CodeLLDB', 'vscode-cpptools'}
vim.g.vimspector_sign_priority = {
    vimspectorBP = 300,
    vimspectorBPCond = 200,
    vimspectorBPDisabled = 100,
    vimspectorPC = 999,
    vimspectorPCBP = 999,
}

m.on_initialize_prompt = function()
    map('n', 'x', 'i-exec<space>', {silent=true, buffer=true})

    if not vim.b.vimspector_command_history then
        vim.b.vimspector_command_history = {}
        vim.b.vimspector_command_history_pos = 0
        m.command_history_initialize()
    end
end

m.on_ui_created = function()
    win_gotoid(vim.g.vimspector_session_windows.output)
    vim.bo.filetype='asm'
    win_gotoid(vim.g.vimspector_session_windows.code)
    vim.cmd [=[
        split
        resize -1000
        enew
    ]=]
    vim.bo.filetype = 'VimspectorPrompt'
    vim.bo.buftype = 'prompt'
    vim.bo.modifiable = false
    vim.bo.textwidth = 0
    vim.opt_local.cursorline = false
    vim.opt_local.number = false
    vim.opt_local.winbar = [=[%#ToolbarButton#%0@v:lua.require'plugins.config.vimspector'.on_winbar_stop@ ■ Stop %X%*]=] ..
                         [=[  %#ToolbarButton#%1@v:lua.require'plugins.config.vimspector'.on_winbar_continue@ ▶ Cont %X%*]=] ..
                         [=[  %#ToolbarButton#%2@v:lua.require'plugins.config.vimspector'.on_winbar_pause@ 󰏤 Pause %X%*]=] ..
                         [=[  %#ToolbarButton#%3@v:lua.require'plugins.config.vimspector'.on_winbar_step_over@ ↷ Next %X%*]=] ..
                         [=[  %#ToolbarButton#%4@v:lua.require'plugins.config.vimspector'.on_winbar_step_into@ → Step %X%*]=] ..
                         [=[  %#ToolbarButton#%5@v:lua.require'plugins.config.vimspector'.on_winbar_step_out@ ← Out %X%*]=] ..
                         [=[  %#ToolbarButton#%6@v:lua.require'plugins.config.vimspector'.on_winbar_restart@ ↺ %X%*]=] ..
                         [=[  %#ToolbarButton#%7@v:lua.require'plugins.config.vimspector'.on_winbar_exit@ ✕ %X%*]=]
    win_gotoid(vim.g.vimspector_session_windows.code)
end

m.command_history_initialize = function()
    map('i', '<cr>', m.command_history_add, {silent=true, buffer=true, expr=true})
    map('i', '<up>', m.command_history_up, {silent=true, buffer=true})
    map('i', '<down>', m.command_history_down, {silent=true, buffer=true})
end

m.command_history_add = function()
    local history = vim.b.vimspector_command_history
    table.insert(history, getline('.'))
    vim.b.vimspector_command_history = history
    vim.b.vimspector_command_history_pos = #vim.b.vimspector_command_history
    return '<cr>'
end

m.command_history_up = function()
    if #vim.b.vimspector_command_history == 0 or vim.b.vimspector_command_history_pos == 0 then
        return
    end

    setline('.', vim.b.vimspector_command_history[vim.b.vimspector_command_history_pos])
    if vim.b.vimspector_command_history_pos ~= 1 then
        vim.b.vimspector_command_history_pos = vim.b.vimspector_command_history_pos - 1
    end
    feed_keys '<c-o>A'
end

m.command_history_down = function()
    if #vim.b.vimspector_command_history == vim.b.vimspector_command_history_pos then
        setline('.', '> ')
    else
        vim.b.vimspector_command_history_pos = vim.b.vimspector_command_history_pos + 1
        setline('.', vim.b.vimspector_command_history[vim.b.vimspector_command_history_pos])
    end
    feed_keys '<c-o>A'
end

m.on_visual_multi_exit = function()
    if vim.bo.filetype == 'VimspectorPrompt' then
        m.command_history_initialize()
    end
end

vim.cmd [=[
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
        if string.find(target, ':', 1, true) and not vim.loop.fs_stat(target) then
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
                "echo '                    { \"text\": \"set disassembly-flavor intel\", \"description\": \"\", \"ignoreFailures\": true },' >> .vimspector.json &&" ..
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
                "echo '                    { \"text\": \"set disassembly-flavor intel\", \"description\": \"\", \"ignoreFailures\": true },' >> .vimspector.json && " ..
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
        if string.find(target, ':', 1, true) and not vim.loop.fs_stat(target) then
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
