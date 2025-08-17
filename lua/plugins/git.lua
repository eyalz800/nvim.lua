local m = {}
local cmd = require 'vim.cmd'.silent
local user = require 'user'
local expand = vim.fn.expand

if user.settings.snacks then
    local git_root = require 'main.root-paths'.git_root
    local lazygit = require 'plugins.config.snacks'.snacks().lazygit
    m.show_git = function() lazygit({ args = { '-p', git_root(expand '%:p:h') } }) end
else
    local terminal = require 'plugins.terminal'.open_floating_terminal
    m.show_git = function()
        terminal(vim.env.SHELL .. ' -c "cd ' .. expand('%:p:h') .. ' ; lazygit"')
    end
end

m.git_blame = function()
    cmd 'Git blame'
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
