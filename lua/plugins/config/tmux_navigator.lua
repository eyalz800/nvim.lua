local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent

v.g.tmux_navigator_no_mappings = true

m.tmux_navigation_enabled = false
if v.env.TMUX then
    m.tmux_navigation_enabled = true
end

m.tmux_navigate_left = function()
    if m.tmux_navigation_enabled then
        cmd 'TmuxNavigateLeft'
    else
        cmd 'wincmd h'
    end
end

m.tmux_navigate_down = function()
    if m.tmux_navigation_enabled then
        cmd 'TmuxNavigateDown'
    else
        cmd 'wincmd j'
    end
end

m.tmux_navigate_up = function()
    if m.tmux_navigation_enabled then
        cmd 'TmuxNavigateUp'
    else
        cmd 'wincmd k'
    end
end

m.tmux_navigate_right = function()
    if m.tmux_navigation_enabled then
        cmd 'TmuxNavigateRight'
    else
        cmd 'wincmd l'
    end
end

return m
