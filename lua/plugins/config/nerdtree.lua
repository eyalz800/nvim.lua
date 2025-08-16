local m = {}
local cmd = require 'vim.cmd'.silent
local expand = vim.fn.expand
local exists = require 'vim.exists'.exists
local file_readable = require 'vim.file-readable'.file_readable

m.init = function()
    vim.g.NERDTreeWinSize = 30
    vim.g.NERDTreeAutoCenter = 0
    vim.g.NERDTreeMinimalUI = 1
    vim.g.NERDTreeShowHidden = 1
    vim.g.NERDTreeAutoDeleteBuffer = 1
    vim.g.NERDTreeDirArrowExpandable = ''
    vim.g.NERDTreeDirArrowCollapsible = ''
    vim.g.NERDTreeDisableExactMatchHighlight = 1
    vim.g.NERDTreeDisablePatternMatchHighlight = 1
    vim.g.NERDTreeLimitedSyntax = 1
    vim.g.NERDTreeSyntaxDisableDefaultExtensions = 0
    vim.g.NERDTreeSyntaxEnabledExtensions = {'h', 'sh', 'bash', 'vim', 'md'}
    vim.g.NERDTreeGitStatusIndicatorMapCustom = {
        Modified  = 'M',
        Staged    = 'A',
        Untracked = 'U',
        Renamed   = '➜',
        Unmerged  = '═',
        Deleted   = '✖',
        Dirty     = 'M',
        Ignored   = '☒',
        Clean     = 'C',
        Unknown   = '?',
    }
    vim.api.nvim_create_autocmd('filetype', {
        pattern = 'nerdtree',
        group = vim.api.nvim_create_augroup('init.lua.nerdtree', {}),
        callback = function()
            vim.opt_local.signcolumn = 'no'
        end
    })

end

m.open = function(options)
    options = options or { focus=true }
    if file_readable(expand('%')) then
        cmd 'NERDTreeFind'
    else
        cmd 'NERDTree'
    end
    if not options.focus then
        cmd 'wincmd w'
    end
end

m.close = function()
    cmd 'NERDTreeClose'
end

m.is_open = function()
    return exists('g:NERDTree') and cmd('echo g:NERDTree.IsOpen()') ~= 0
end

m.toggle = function()
    if m.is_open() then
        m.close()
    else
        m.open({ focus=false })
    end
end

m.open_current_directory = function(options)
    options = options or { focus=true }

    cmd 'NERDTreeCWD'
    cmd 'NERDTreeRefreshRoot'

    if not options.focus then
        cmd('wincmd w')
    end
end

return m
