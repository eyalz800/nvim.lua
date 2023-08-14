local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent
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

return m
