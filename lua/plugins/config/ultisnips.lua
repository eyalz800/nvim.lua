local m = {}
local v = require 'vim'
local user = require 'user'

v.g.UltiSnipsSnippetDirectories = {'UltiSnips', 'vim-ultisnips'}
if user.settings.lsp ~= 'coc' then
    v.g.UltiSnipsExpandTrigger = '<c-d>'
end

return m
