local m = {}
local user = require 'user'

require 'plugins.config.airline'

if user.settings.lsp == 'coc' then
    require 'plugins.config.coc'
end

if user.settings.file_explorer == 'nerdtree' then
    require 'plugins.config.nerdtree'
end

if user.settings.code_explorer == 'tagbar' then
    require 'plugins.config.tagbar'
end

if user.settings.git_plugin == 'gitgutter' then
    require 'plugins.config.gitgutter'
end

require 'plugins.config.magit'

require 'plugins.config.fzf'
require 'plugins.config.visual_multi'
require 'plugins.config.tmux_navigator'
require 'plugins.config.ultisnips'
require 'plugins.config.devicons'
require 'plugins.config.hexokinase'
require 'plugins.config.vimspector'
require 'plugins.config.asynctasks'
require 'plugins.config.pear-tree'
require 'plugins.config.vim-signature'
require 'plugins.config.abolish'
require 'plugins.config.zip'

return m
