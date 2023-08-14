local m = {}
local v = require 'vim'

v.cmd [=[

nnoremap <silent> <leader>dl :call ZVimspectorDebugLaunchSettings()<CR>
nnoremap <silent> <leader>dd :if !filereadable('.vimspector.json') \| call ZVimspectorDebugLaunchSettings() \| endif \| call vimspector#Launch()<CR>
nmap <leader>dc <plug>VimspectorContinue
nmap <F5> <plug>VimspectorContinue
nmap <leader>dr <plug>VimspectorRestart
if !has('nvim')
    nmap <S-F5> <plug>VimspectorRestart
else
    nmap <F17> <plug>VimspectorRestart
endif
nmap <leader>dp <plug>VimspectorPause
nmap <F6> <plug>VimspectorPause
nmap <leader>ds <plug>VimspectorStop
if !has('nvim')
    nmap <S-F6> <plug>VimspectorStop
else
    nmap <F18> <plug>VimspectorStop
endif
nmap <leader>db <plug>VimspectorToggleBreakpoint
nmap <F9> <plug>VimspectorToggleBreakpoint
nmap <leader><leader>db <plug>VimspectorToggleConditionalBreakpoint
if !has('nvim')
    nmap <S-F9> <plug>VimspectorToggleConditionalBreakpoint
else
    nmap <F21> <plug>VimspectorToggleConditionalBreakpoint
endif
nmap <leader>df <plug>VimspectorAddFunctionBreakpoint
nmap <leader><F9> <plug>VimspectorAddFunctionBreakpoint
nnoremap <silent> <leader>dB :call vimspector#ClearBreakpoints()<CR>
nnoremap <silent> <leader><leader><F9> :call vimspector#ClearBreakpoints()<CR>
nmap <leader>dn <plug>VimspectorStepOver
nnoremap <silent> <F10> :exec "normal \<plug>VimspectorStepOver"<CR>
nmap <leader>di <plug>VimspectorStepInto
nnoremap <silent> <S-F10> :exec "normal \<plug>VimspectorStepInto"<CR>
nnoremap <silent> <F11> :exec "normal \<plug>VimspectorStepInto"<CR>
nmap <leader>do <plug>VimspectorStepOut
if !has('nvim')
    nmap <S-F11> <plug>VimspectorStepOut
else
    nmap <F23> <plug>VimspectorStepOut
endif
nnoremap <silent> <leader>dq :VimspectorReset<CR>
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
augroup ZVimspectorCustomMappings
    autocmd!
    autocmd FileType VimspectorPrompt call ZVimspectorInitializePrompt()
    autocmd User VimspectorUICreated call ZVimspectorSetupUi()
augroup end
function! ZVimspectorSetupUi()
    call win_gotoid(g:vimspector_session_windows.output)
    set ft=asm
    call win_gotoid(g:vimspector_session_windows.code)
endfunction
function! ZVimspectorInitializePrompt()
    nnoremap <silent> <buffer> x i-exec<space>
    if !exists('b:vimspector_command_history')
        call ZVimspectorInitializeCommandHistoryMaps()
        let b:vimspector_command_history = []
        let b:vimspector_command_history_pos = 0
    endif
endfunction
function! ZVimspectorInitializeCommandHistoryMaps()
    inoremap <silent> <buffer> <CR> <C-o>:call ZVimspectorCommandHistoryAdd()<CR>
    inoremap <silent> <buffer> <Up> <C-o>:call ZVimspectorCommandHistoryUp()<CR>
    inoremap <silent> <buffer> <Down> <C-o>:call ZVimspectorCommandHistoryDown()<CR>
endfunction
function! ZVimspectorCommandHistoryAdd()
    call add(b:vimspector_command_history, getline('.'))
    let b:vimspector_command_history_pos = len(b:vimspector_command_history)
    call feedkeys("\<CR>", 'tn')
endfunction
function! ZVimspectorCommandHistoryUp()
    if len(b:vimspector_command_history) == 0 || b:vimspector_command_history_pos == 0
        return
    endif
    call setline('.', b:vimspector_command_history[b:vimspector_command_history_pos - 1])
    call feedkeys("\<C-o>A", 'tn')
    let b:vimspector_command_history_pos = b:vimspector_command_history_pos - 1
endfunction
function! ZVimspectorCommandHistoryDown()
    if b:vimspector_command_history_pos == len(b:vimspector_command_history)
        return
    endif
    call setline('.', b:vimspector_command_history[b:vimspector_command_history_pos - 1])
    call feedkeys("\<C-o>A", 'tn')
    let b:vimspector_command_history_pos = b:vimspector_command_history_pos + 1
endfunction
augroup ZVisualMultiVimspector
    autocmd!
    autocmd User visual_multi_exit if &ft == 'VimspectorPrompt' | call ZVimspectorInitializeCommandHistoryMaps() | endif
augroup end
function! ZVimspectorGenerateCpp()
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
function! ZVimspectorGeneratePy()
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
function! ZVimspectorDebugLaunchSettings()
    let debug_type = &filetype
    if debug_type != 'cpp' && debug_type != 'c' && debug_type != 'python'
        call inputsave()
        let debug_type = input('Debugger type (cpp/python): ')
        call inputrestore()
    endif

    if debug_type == 'cpp' || debug_type == 'c'
        call ZVimspectorGenerateCpp()
    elseif debug_type == 'python'
        call ZVimspectorGeneratePy()
    else
        normal :<ESC>
        echom 'Invalid debug type.'
    endif
endfunction

]=]

return m
