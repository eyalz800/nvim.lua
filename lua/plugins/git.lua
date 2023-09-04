local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent
local user = require 'user'
local terminal = require 'plugins.terminal'.open_floating_terminal
local expand = v.fn.expand

m.show_git = function()
    terminal(v.env.SHELL .. ' -c "cd ' .. expand('%:p:h') .. ' ; lazygit"')
end

m.git_blame = function()
    cmd 'Git blame'
end

m.git_commits = function()
    cmd 'BCommits'
end

m.show_staging_buffer = function()
    cmd 'MagitOnly'
end

if user.settings.git_plugin == 'gitsigns' then
    local gitsigns = require 'plugins.config.gitsigns'
    m.git_blame_current_line = gitsigns.git_blame_current_line
    m.prev_hunk = gitsigns.prev_hunk
    m.next_hunk = gitsigns.next_hunk
else
    m.git_blame_current_line = function() end
    m.prev_hunk = function() end
    m.next_hunk = function() end
end

return m
