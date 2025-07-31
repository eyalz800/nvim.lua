local m = {}
local user = require 'user'

vim.g.UltiSnipsSnippetDirectories = {'UltiSnips', 'vim-ultisnips'}
if user.settings.lsp ~= 'coc' then
    vim.g.UltiSnipsExpandTrigger = '<c-d>'
end

return m
