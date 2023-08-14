local m = {}
local v = require 'vim'
local os = require 'lib.os'.os
local user = require 'user'
local feed_keys = require 'vim.feed_keys'.feed_keys
local cmd = require 'vim.cmd'.silent

local define_ptty_osc_copy = function()
    v.cmd([[
function! Init_lua_osc_copy()
    let encodedText=@"
    let encodedText=substitute(encodedText, '\', '\\\\', "g")
    let encodedText=substitute(encodedText, "'", "'\\\\''", "g")
    let executeCmd="echo -n '".encodedText."' | base64 | tr -d '\\n'"
    let encodedText=system(executeCmd)
    if !exists('g:vim_tty')
        let g:vim_tty = system('(tty || tty </proc/$PPID/fd/0) 2>/dev/null | grep /dev/')
    endif
    if !empty($TMUX)
        let executeCmd='echo -en "\x1bPtmux;\x1b\x1b]52;;'.encodedText.'\x1b\x1b\\\\\x1b\\" > ' . g:vim_tty
    else
        let executeCmd='echo -en "\x1b]52;;'.encodedText.'\x1b\\" > ' . g:vim_tty
    endif
    call system(executeCmd)
endfunction
]])
end

local define_regular_osc_copy = function()
    v.cmd([[
function! Init_lua_osc_copy()
    let encodedText=@"
    let encodedText=substitute(encodedText, '\', '\\\\', "g")
    let encodedText=substitute(encodedText, "'", "'\\\\''", "g")
    let executeCmd="echo -n '".encodedText."' | base64 | tr -d '\\n'"
    let encodedText=system(executeCmd)
    if !empty($TMUX)
        let executeCmd='echo -en "\x1bPtmux;\x1b\x1b]52;;'.encodedText.'\x1b\x1b\\\\\x1b\\" > /dev/tty'
    else
        let executeCmd='echo -en "\x1b]52;;'.encodedText.'\x1b\\" > /dev/tty'
    endif
    call system(executeCmd)
endfunction
]])
end

if user.settings.osc_copy then
    if os ~= "Darwin" then
        define_ptty_osc_copy()
        m.copy = function()
            feed_keys '""y'
            cmd 'call Init_lua_osc_copy()'
        end

        m.cut = function()
            feed_keys '""d'
            cmd 'call Init_lua_osc_copy()'
        end

        m.paste = function()
            local mode = v.fn.mode()
            if mode == 'i' then
                feed_keys '<C-o>""gp'
            elseif mode == 'n' then
                feed_keys '""p'
            end
        end
    else
        define_regular_osc_copy()
        m.copy = function()
            feed_keys '"*y'
            cmd 'call Init_lua_osc_copy()'
        end

        m.cut = function()
            feed_keys '"*d'
            cmd 'call Init_lua_osc_copy()'
        end

        m.paste = function()
            local mode = v.fn.mode()
            if mode == 'i' then
                feed_keys '<C-o>"*gp'
            elseif mode == 'n' then
                feed_keys '"*p'
            end
        end
    end
else
    m.copy = function()
        feed_keys '"*y'
    end

    m.cut = function()
        feed_keys '"*d'
    end

    m.paste = function()
        local mode = v.fn.mode()
        if mode == 'i' then
            feed_keys '<C-o>"*gp'
        elseif mode == 'n' then
            feed_keys '"*p'
        end
    end
end

return m
