local m = {}
local v = require 'vim'
local exists = require 'vim.exists'.exists
local cmd = require 'vim.cmd'.silent
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
    if get_current_file_size() >= 2 * 1024 * 1024 then
        v.opt_local.cursorline = false
        v.opt_local.swapfile = false
        v.opt_local.bufhidden = 'unload'
        v.opt_local.undofile = false
        v.opt_local.undolevels = -1
        v.opt_local.undoreload = 0
        v.opt_local.list = false
        v.opt_local.foldmethod = 'manual'
        v.b.large_file_deferred = {}
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
        if exists '*signature#utils#Toggle' then
            v.b.sig_enabled = 0
        end
        if exists ':CocDisable' then
            table.insert(v.b.large_file_deferred, 'CocDisable')
        end
        if exists ':TSBufDisable' then
            table.insert(v.b.large_file_deferred, 'TSBufDisable highlight')
        end
        if user.settings.bar == 'barbecue' then
            require 'barbecue.ui'.toggle(false)
        end
        if user.settings.lsp == 'nvim' then
            table.insert(v.b.large_file_deferred, 'LspStop')
            require 'cmp'.setup.buffer({ enabled = false })
        end
        if user.settings.pairs == 'nvim-autopairs' then
            table.insert(v.b.large_file_deferred, "lua require 'nvim-autopairs'.disable()")
        end
    end
end

m.on_buf_read_post = function()
    if v.b.large_file_deferred then
        for _, command in ipairs(v.b.large_file_deferred) do
            cmd(command)
        end
    end
end

return m
