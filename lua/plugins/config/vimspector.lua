local m = {}
local v = require 'vim'
local file_readable = require 'vim.file_readable'.file_readable

m.launch_settings = function()
    v.fn.Init_lua_vimspector_debug_launch_settings()
end

m.launch = function()
    if not file_readable('.vimspector.json') then
        v.fn.Init_lua_vimspector_debug_launch_settings()
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

v.cmd [=[

let g:vimspector_install_gadgets = ['debugpy', 'CodeLLDB']
let g:vimspector_sign_priority = {
  \    'vimspectorBP':         300,
  \    'vimspectorBPCond':     200,
  \    'vimspectorBPDisabled': 100,
  \    'vimspectorPC':         999,
  \    'vimspectorPCBP':       999,
  \ }
sign define vimspectorBP            text= texthl=MatchParen
sign define vimspectorBPCond        text= texthl=MatchParen
sign define vimspectorBPLog         text=󰛿 texthl=MatchParen
sign define vimspectorBPDisabled    text= texthl=LineNr
sign define vimspectorPC            text= texthl=String linehl=CursorLine
sign define vimspectorPCBP          text= texthl=String linehl=CursorLine
let s:disable_codelldb_default = filereadable(expand('~/.vim/.disable_codelldb_default'))
augroup init.lua.vimspector.custom_mappings
    autocmd!
    autocmd FileType VimspectorPrompt call Init_lua_vimspector_initialize_prompt()
    autocmd User VimspectorUICreated call Init_lua_vimspector_setup_ui()
augroup end
function! Init_lua_vimspector_setup_ui()
    call win_gotoid(g:vimspector_session_windows.output)
    set ft=asm
    call win_gotoid(g:vimspector_session_windows.code)
    split
    resize -1000
    enew
    setlocal ft=VimspectorPrompt
    setlocal buftype=prompt
    setlocal nomodifiable
    setlocal nocursorline
    setlocal nonumber
    setlocal textwidth=0
    setlocal winbar=%#ToolbarButton#%0@v:lua.require'plugins.config.vimspector'.on_winbar_stop@\ ■\ Stop\ %X%*\ \ %#ToolbarButton#%1@v:lua.require'plugins.config.vimspector'.on_winbar_continue@\ ▶\ Cont\ %X%*\ \ %#ToolbarButton#%2@v:lua.require'plugins.config.vimspector'.on_winbar_pause@\ 󰏤\ Pause\ %X%*\ \ %#ToolbarButton#%3@v:lua.require'plugins.config.vimspector'.on_winbar_step_over@\ ↷\ Next\ %X%*\ \ %#ToolbarButton#%4@v:lua.require'plugins.config.vimspector'.on_winbar_step_into@\ →\ Step\ %X%*\ \ %#ToolbarButton#%5@v:lua.require'plugins.config.vimspector'.on_winbar_step_out@\ ←\ Out\ %X%*\ \ %#ToolbarButton#%6@v:lua.require'plugins.config.vimspector'.on_winbar_restart@\ ↺\ %X%*\ \ %#ToolbarButton#%7@v:lua.require'plugins.config.vimspector'.on_winbar_exit@\ ✕\ %X%*
    call win_gotoid(g:vimspector_session_windows.code)
endfunction
function! Init_lua_vimspector_initialize_prompt()
    nnoremap <silent> <buffer> x i-exec<space>
    if !exists('b:vimspector_command_history')
        call Init_lua_vimspector_initialize_command_history_maps()
        let b:vimspector_command_history = []
        let b:vimspector_command_history_pos = 0
    endif
endfunction
function! Init_lua_vimspector_initialize_command_history_maps()
    inoremap <silent> <buffer> <cr> <C-o>:call Init_lua_vimspector_command_history_add()<cr>
    inoremap <silent> <buffer> <Up> <C-o>:call Init_lua_vimspector_command_history_up()<cr>
    inoremap <silent> <buffer> <Down> <C-o>:call Init_lua_vimspector_command_history_down()<cr>
endfunction
function! Init_lua_vimspector_command_history_add()
    call add(b:vimspector_command_history, getline('.'))
    let b:vimspector_command_history_pos = len(b:vimspector_command_history)
    call feedkeys("\<cr>", 'tn')
endfunction
function! Init_lua_vimspector_command_history_up()
    if len(b:vimspector_command_history) == 0 || b:vimspector_command_history_pos == 0
        return
    endif
    call setline('.', b:vimspector_command_history[b:vimspector_command_history_pos - 1])
    call feedkeys("\<C-o>A", 'tn')
    let b:vimspector_command_history_pos = b:vimspector_command_history_pos - 1
endfunction
function! Init_lua_vimspector_command_history_down()
    if b:vimspector_command_history_pos == len(b:vimspector_command_history)
        return
    endif
    call setline('.', b:vimspector_command_history[b:vimspector_command_history_pos - 1])
    call feedkeys("\<C-o>A", 'tn')
    let b:vimspector_command_history_pos = b:vimspector_command_history_pos + 1
endfunction
augroup init.lua.vimspector.visual_multi_exit
    autocmd!
    autocmd User visual_multi_exit if &ft == 'VimspectorPrompt' | call Init_lua_vimspector_initialize_command_history_maps() | endif
augroup end
function! Init_lua_vimspector_generate_cpp()
    call inputsave()
    let target = input('Target (Executable/IP): ')
    call inputrestore()
    let debugger = 'gdb'
    if !executable('gdb') && executable('lldb')
        let debugger = 'lldb'
    endif
    if s:disable_codelldb_default " vscode-cpptools
        if stridx(target, ':') != -1 && !filereadable(target)
            call inputsave()
            let main_file = input('Main File: ')
            call inputrestore()
            call system("
                \ echo '{' > .vimspector.json &&
                \ echo '    \"configurations\": {' >> .vimspector.json &&
                \ echo '        \"Launch\": {' >> .vimspector.json &&
                \ echo '            \"adapter\": \"vscode-cpptools\",' >> .vimspector.json &&
                \ echo '            \"configuration\": {' >> .vimspector.json &&
                \ echo '                \"request\": \"launch\",' >> .vimspector.json &&
                \ echo '                \"program\": \"" . main_file . "\",' >> .vimspector.json &&
                \ echo '                \"cwd\": \"${workspaceRoot}\",' >> .vimspector.json &&
                \ echo '                \"type\": \"cppdbg\",' >> .vimspector.json &&
                \ echo '                \"setupCommands\": [' >> .vimspector.json &&
                \ echo '                    { \"text\": \"set disassembly-flavor intel\", \"description\": \"\", \"ignoreFailures\": false },' >> .vimspector.json &&
                \ echo '                    { \"text\": \"-enable-pretty-printing\", \"description\": \"\", \"ignoreFailures\": false }' >> .vimspector.json &&
                \ echo '                ],' >> .vimspector.json &&
                \ echo '                \"miDebuggerServerAddress\": \"" . target . "\",' >> .vimspector.json &&
                \ echo '                \"externalConsole\": true,' >> .vimspector.json &&
                \ echo '                \"stopAtEntry\": true,' >> .vimspector.json &&
                \ echo '                \"miDebuggerPath\": \"" . debugger . "\",' >> .vimspector.json &&
                \ echo '                \"MIMode\": \"" . debugger . "\"' >> .vimspector.json &&
                \ echo '            }' >> .vimspector.json &&
                \ echo '        }' >> .vimspector.json &&
                \ echo '    }' >> .vimspector.json &&
                \ echo '}' >> .vimspector.json")
        else
            call system("
                \ echo '{' > .vimspector.json &&
                \ echo '    \"configurations\": {' >> .vimspector.json &&
                \ echo '        \"Launch\": {' >> .vimspector.json &&
                \ echo '            \"adapter\": \"vscode-cpptools\",' >> .vimspector.json &&
                \ echo '            \"configuration\": {' >> .vimspector.json &&
                \ echo '                \"request\": \"launch\",' >> .vimspector.json &&
                \ echo '                \"type\": \"cppdbg\",' >> .vimspector.json &&
                \ echo '                \"program\": \"" . target . "\",' >> .vimspector.json &&
                \ echo '                \"args\": [],' >> .vimspector.json &&
                \ echo '                \"environment\": [],' >> .vimspector.json &&
                \ echo '                \"cwd\": \"${workspaceRoot}\",' >> .vimspector.json &&
                \ echo '                \"externalConsole\": true,' >> .vimspector.json &&
                \ echo '                \"stopAtEntry\": true,' >> .vimspector.json &&
                \ echo '                \"setupCommands\": [' >> .vimspector.json &&
                \ echo '                    { \"text\": \"set disassembly-flavor intel\", \"description\": \"\", \"ignoreFailures\": false },' >> .vimspector.json &&
                \ echo '                    { \"text\": \"-enable-pretty-printing\", \"description\": \"\", \"ignoreFailures\": false }' >> .vimspector.json &&
                \ echo '                ],' >> .vimspector.json &&
                \ echo '                \"MIMode\": \"" . debugger . "\"' >> .vimspector.json &&
                \ echo '            }' >> .vimspector.json &&
                \ echo '        }' >> .vimspector.json &&
                \ echo '    }' >> .vimspector.json &&
                \ echo '}' >> .vimspector.json")
        endif
    else " CodeLLDB
        if executable('lldb')
            let debugger = 'lldb'
        endif
        if stridx(target, ':') != -1 && !filereadable(target)
            call inputsave()
            let main_file = input('Main File: ')
            call inputrestore()
            call system("
                \ echo '{' > .vimspector.json &&
                \ echo '    \"configurations\": {' >> .vimspector.json &&
                \ echo '        \"Launch\": {' >> .vimspector.json &&
                \ echo '            \"adapter\": \"CodeLLDB\",' >> .vimspector.json &&
                \ echo '            \"configuration\": {' >> .vimspector.json &&
                \ echo '                \"name\": \"remote attach\",' >> .vimspector.json &&
                \ echo '                \"request\": \"launch\",' >> .vimspector.json &&
                \ echo '                \"custom\": true,' >> .vimspector.json &&
                \ echo '                \"type\": \"" . debugger . "\",' >> .vimspector.json &&
                \ echo '                \"targetCreateCommands\": [\"target create " . main_file . "\"],' >> .vimspector.json &&
                \ echo '                \"processCreateCommands\": [\"gdb-remote " . target . "\"],' >> .vimspector.json &&
                \ echo '                \"args\": [],' >> .vimspector.json &&
                \ echo '                \"environment\": [],' >> .vimspector.json &&
                \ echo '                \"cwd\": \"${workspaceRoot}\",' >> .vimspector.json &&
                \ echo '                \"terminal\": \"external\",' >> .vimspector.json &&
                \ echo '                \"stopOnEntry\": true,' >> .vimspector.json &&
                \ echo '                \"sourceMap\": {' >> .vimspector.json &&
                \ echo '                    \"\": \"\"' >> .vimspector.json &&
                \ echo '                },' >> .vimspector.json &&
                \ echo '                \"initCommands\": [' >> .vimspector.json &&
                \ echo '                    \"settings set target.x86-disassembly-flavor intel\"' >> .vimspector.json &&
                \ echo '                ]' >> .vimspector.json &&
                \ echo '            },' >> .vimspector.json &&
                \ echo '            \"breakpoints\": {' >> .vimspector.json &&
                \ echo '                \"exception\": {' >> .vimspector.json &&
                \ echo '                    \"cpp_throw\": \"N\",' >> .vimspector.json &&
                \ echo '                    \"cpp_catch\": \"N\"' >> .vimspector.json &&
                \ echo '                }' >> .vimspector.json &&
                \ echo '            }' >> .vimspector.json &&
                \ echo '        }' >> .vimspector.json &&
                \ echo '    }' >> .vimspector.json &&
                \ echo '}' >> .vimspector.json")
        else
            call system("
                \ echo '{' > .vimspector.json &&
                \ echo '    \"configurations\": {' >> .vimspector.json &&
                \ echo '        \"Launch\": {' >> .vimspector.json &&
                \ echo '            \"adapter\": \"CodeLLDB\",' >> .vimspector.json &&
                \ echo '            \"configuration\": {' >> .vimspector.json &&
                \ echo '                \"name\": \"launch\",' >> .vimspector.json &&
                \ echo '                \"request\": \"launch\",' >> .vimspector.json &&
                \ echo '                \"type\": \"" . debugger . "\",' >> .vimspector.json &&
                \ echo '                \"program\": \"" . target . "\",' >> .vimspector.json &&
                \ echo '                \"args\": [],' >> .vimspector.json &&
                \ echo '                \"environment\": [],' >> .vimspector.json &&
                \ echo '                \"cwd\": \"${workspaceRoot}\",' >> .vimspector.json &&
                \ echo '                \"terminal\": \"external\",' >> .vimspector.json &&
                \ echo '                \"stopOnEntry\": true,' >> .vimspector.json &&
                \ echo '                \"initCommands\": [' >> .vimspector.json &&
                \ echo '                    \"settings set target.x86-disassembly-flavor intel\"' >> .vimspector.json &&
                \ echo '                ]' >> .vimspector.json &&
                \ echo '            },' >> .vimspector.json &&
                \ echo '            \"breakpoints\": {' >> .vimspector.json &&
                \ echo '                \"exception\": {' >> .vimspector.json &&
                \ echo '                    \"cpp_throw\": \"N\",' >> .vimspector.json &&
                \ echo '                    \"cpp_catch\": \"N\"' >> .vimspector.json &&
                \ echo '                }' >> .vimspector.json &&
                \ echo '            }' >> .vimspector.json &&
                \ echo '        }' >> .vimspector.json &&
                \ echo '    }' >> .vimspector.json &&
                \ echo '}' >> .vimspector.json")
        endif
    endif
endfunction
function! Init_lua_vimspector_generate_py()
    call inputsave()
    let program = input('Python main file: ')
    let python = 'python3'
    call inputrestore()
    call system("
        \ echo '{' > .vimspector.json &&
        \ echo '    \"configurations\": {' >> .vimspector.json &&
        \ echo '        \"Launch\": {' >> .vimspector.json &&
        \ echo '            \"adapter\": \"debugpy\",' >> .vimspector.json &&
        \ echo '            \"breakpoints\": {\"exception\": {\"raised\": \"N\", \"uncaught\": \"Y\"}},' >> .vimspector.json &&
        \ echo '            \"configuration\": {' >> .vimspector.json &&
        \ echo '                \"request\": \"launch\",' >> .vimspector.json &&
        \ echo '                \"type\": \"python\",' >> .vimspector.json &&
        \ echo '                \"program\": \"" . program . "\",' >> .vimspector.json &&
        \ echo '                \"args\": [],' >> .vimspector.json &&
        \ echo '                \"python\": \"" . python . "\",' >> .vimspector.json &&
        \ echo '                \"cwd\": \"${workspaceRoot}\",' >> .vimspector.json &&
        \ echo '                \"externalConsole\": true,' >> .vimspector.json &&
        \ echo '                \"stopAtEntry\": true' >> .vimspector.json &&
        \ echo '            }' >> .vimspector.json &&
        \ echo '        }' >> .vimspector.json &&
        \ echo '    }' >> .vimspector.json &&
        \ echo '}' >> .vimspector.json")
endfunction
function! Init_lua_vimspector_debug_launch_settings()
    let debug_type = &filetype
    if debug_type != 'cpp' && debug_type != 'c' && debug_type != 'python'
        call inputsave()
        let debug_type = input('Debugger type (cpp/python): ')
        call inputrestore()
    endif

    if debug_type == 'cpp' || debug_type == 'c'
        call Init_lua_vimspector_generate_cpp()
    elseif debug_type == 'python'
        call Init_lua_vimspector_generate_py()
    else
        normal :<esc>
        echom 'Invalid debug type.'
    endif
endfunction

]=]

return m
