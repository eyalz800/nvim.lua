local m = {}
local user = require 'user'

require 'plugins.config.zip'
require 'plugins.config.visual_multi'
require 'plugins.config.tmux_navigator'
require 'plugins.config.asynctasks'
require 'plugins.config.abolish'


if user.settings.colorizer == 'hexokinase' then
    require 'plugins.config.hexokinase'
end

if user.settings.line == 'airline' then
    require 'plugins.config.airline'
end

if user.settings.lsp == 'coc' then
    require 'plugins.config.coc'
    require 'plugins.config.ultisnips'
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

if user.settings.finder == 'fzf' or user.settings.finder == 'fzf-lua' then
    require 'plugins.config.fzf'
end

if user.settings.file_explorer == 'nerdtree' then
    require 'plugins.config.devicons'
end

if user.settings.pairs == 'pear-tree' then
    require 'plugins.config.pear-tree'
end

if user.settings.debugger == 'vimspector' then
    require 'plugins.config.vimspector'
end

return m
