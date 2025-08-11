local m = {}

vim.g.fugitive_summary_format = "%as (%cr) %an <%ae> : %s"

m.setup = function()
    vim.api.nvim_create_autocmd('filetype', {
        pattern = 'fugitiveblame',
        group = vim.api.nvim_create_augroup('init.lua.fugitive-diffview', {}),
        command =
        [=[nnoremap <buffer> <silent> q <cmd>q<cr> | nnoremap <buffer> <silent> d <cmd>silent exec 'norm! 0eb"xyw' <bar> wincmd l <bar> silent exec 'DiffviewFileHistory % --range='.getreg('x')<cr>]=]
    })
end

return m
