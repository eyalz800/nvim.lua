local m = {}
local exists = require 'vim.exists'.exists
local cmd = require 'vim.cmd'.silent
local echo = require 'vim.echo'.echo
local user = require 'user'

local get_current_file_size = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local ok, stats = pcall(function()
        return vim.loop.fs_stat(vim.api.nvim_buf_get_name(bufnr))
    end)
    if not (ok and stats) then
        return 0
    end
    return stats.size
end

m.setup = function()
    vim.api.nvim_create_autocmd('bufreadpre', {
        group = vim.api.nvim_create_augroup('init.lua.large-files-pre', {}),
        callback = m.on_buf_read_pre
    })

    vim.api.nvim_create_autocmd('bufreadpost', {
        group = vim.api.nvim_create_augroup('init.lua.large-files-post', {}),
        callback = m.on_buf_read_post
    })
end

m.on_buf_read_pre = function()
    if get_current_file_size() >= 10 * 1024 * 1024 then
        m.set()
    end
end

m.set = function()
    local buf = vim.api.nvim_get_current_buf()
    vim.opt_local.cursorline = false
    vim.opt_local.swapfile = false
    vim.opt_local.bufhidden = 'unload'
    vim.opt_local.undofile = false
    vim.opt_local.undolevels = -1
    vim.opt_local.undoreload = 0
    vim.opt_local.list = false
    vim.opt_local.filetype = ''
    vim.opt_local.foldmethod = 'manual'
    vim.b.large_file = true
    local large_file_deferred = {}
    if exists ':AirlineToggle' then
        cmd 'AirlineToggle'
    end
    if exists ':DoMatchParen' then
        cmd 'NoMatchParen'
    end
    if exists ':PearTreeDisable' then
        cmd 'PearTreeDisable'
    end
    if exists ':IndentBlankLineDisable' then
        cmd 'IndentBlankLineDisable'
    end
    if exists ':ColorizerDetachFromBuffer' then
        cmd 'ColorizerDetachFromBuffer'
    end
    if exists '*signature#utils#Toggle' then
        vim.b.sig_enabled = 0
    end
    if exists ':CocDisable' then
        table.insert(large_file_deferred, 'CocDisable')
    end
    if exists ':TSBufDisable' then
        cmd ':TSBufDisable highlight'
    end
    if exists ':DisableWhitespace' then
        cmd 'DisableWhitespace'
    end
    if user.settings.lsp == 'nvim' then
        require 'cmp'.setup({ enabled = false })
        vim.api.nvim_create_autocmd({ 'LspAttach' }, {
            buffer = buf,
            callback = function(args)
                vim.schedule(function()
                    vim.lsp.buf_detach_client(buf, args.data.client_id)
                end)
            end,
        })
    end
    if user.settings.pairs == 'nvim-autopairs' then
        table.insert(large_file_deferred, "lua require 'nvim-autopairs'.disable()")
    end
    vim.b.large_file_deferred = large_file_deferred
    echo 'large file mode!'
end

m.on_buf_read_post = function()
    if vim.b.large_file_deferred then
        for _, command in ipairs(vim.b.large_file_deferred) do
            cmd(command)
        end
    end
end

return m
