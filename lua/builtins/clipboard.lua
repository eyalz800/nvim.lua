local m = {}
local v = require 'vim'
local os = require 'lib.os'.os
local user = require 'user'
local feed_keys = require 'vim.feed_keys'.feed_keys
local system = v.fn.system
local getreg = v.fn.getreg

local tty = nil

local osc_encode = function(text)
    local encoded_text = string.gsub(text, [=[\]=], [=[\\]=])
    encoded_text = string.gsub(encoded_text, "'", [=['\'']=])
    return system("echo -n '" .. encoded_text .. [=[' | base64 | tr -d '\n']=])
end

local ptty_osc_copy = function()
    if not tty then
        tty = system('(tty || tty </proc/$PPID/fd/0) 2>/dev/null | grep /dev/')
    end

    if v.env.TMUX then
        system([=[echo -en "\x1bPtmux;\x1b\x1b]52;;]=] .. osc_encode(getreg('@', 1)) .. [=[\x1b\x1b\\\\\x1b\\" > ]=] .. tty)
    else
        system([=[echo -en "\x1b]52;;]=] .. osc_encode(getreg('@', 1)) .. [=[\x1b\\" > ]=] .. tty)
    end
end

local osc_copy = function()
    if v.env.TMUX then
        system([=[echo -en "\x1bPtmux;\x1b\x1b]52;;]=] .. osc_encode(getreg('@', 1)) .. [=[\x1b\x1b\\\\\x1b\\" > /dev/tty]=])
    else
        system([=[echo -en "\x1b]52;;]=] .. osc_encode(getreg('@', 1)) .. [=[\x1b\\" > /dev/tty]=])
    end
end

if user.settings.osc_copy then
    if os ~= "Darwin" then
        m.copy = function()
            feed_keys('""y', 'x')
            ptty_osc_copy()
        end

        m.cut = function()
            feed_keys('""d', 'x')
            ptty_osc_copy()
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
        m.copy = function()
            feed_keys('"*y', 'x')
            osc_copy()
        end

        m.cut = function()
            feed_keys('"*d', 'x')
            osc_copy()
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
