local m = {}
local v = require 'vim'
local exists = require 'vim.exists'.exists
local cmd = require 'vim.cmd'.silent
local echo = require 'vim.echo'.echo
local user = require 'user'

local get_current_file_size = function()
    local bufnr = v.api.nvim_get_current_buf()
    local ok, stats = pcall(function()
        return v.loop.fs_stat(v.api.nvim_buf_get_name(bufnr))
    end)
    if not (ok and stats) then
        return 0
    end
    return stats.size
end

m.on_buf_read_pre = function()
    if get_current_file_size() >= 10 * 1024 * 1024 then
        m.set()
    end
end

m.set = function()
    local buf = v.api.nvim_get_current_buf()
    v.opt_local.cursorline = false
    v.opt_local.swapfile = false
    v.opt_local.bufhidden = 'unload'
    v.opt_local.undofile = false
    v.opt_local.undolevels = -1
    v.opt_local.undoreload = 0
    v.opt_local.list = false
    v.opt_local.filetype = ''
    v.opt_local.foldmethod = 'manual'
    v.b.large_file = true
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
    if exists ':HexokinaseTurnOff' then
        cmd 'HexokinaseTurnOff'
    end
    if exists ':ColorizerDetachFromBuffer' then
        cmd 'ColorizerDetachFromBuffer'
    end
    if exists '*signature#utils#Toggle' then
        v.b.sig_enabled = 0
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
        v.api.nvim_create_autocmd({ 'LspAttach' }, {
            buffer = buf,
            callback = function(args)
                v.schedule(function()
                    v.lsp.buf_detach_client(buf, args.data.client_id)
                end)
            end,
        })
    end
    if user.settings.pairs == 'nvim-autopairs' then
        table.insert(large_file_deferred, "lua require 'nvim-autopairs'.disable()")
    end
    v.b.large_file_deferred = large_file_deferred
    echo 'large file mode!'
end

m.on_buf_read_post = function()
    if v.b.large_file_deferred then
        for _, command in ipairs(v.b.large_file_deferred) do
            cmd(command)
        end
    end
end

return m
