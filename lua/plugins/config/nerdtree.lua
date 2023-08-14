local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent
local expand = v.fn.expand
local exists = require 'vim.exists'.exists
local file_readable = require 'vim.file_readable'.file_readable

v.g.NERDTreeWinSize = 30
v.g.NERDTreeAutoCenter = 0
v.g.NERDTreeMinimalUI = 1
v.g.NERDTreeShowHidden = 1
v.g.NERDTreeAutoDeleteBuffer = 1
v.g.NERDTreeDirArrowExpandable = ''
v.g.NERDTreeDirArrowCollapsible = ''
v.g.NERDTreeDisableExactMatchHighlight = 1
v.g.NERDTreeDisablePatternMatchHighlight = 1
v.g.NERDTreeLimitedSyntax = 1
v.g.NERDTreeSyntaxDisableDefaultExtensions = 0
v.g.NERDTreeSyntaxEnabledExtensions = {'h', 'sh', 'bash', 'vim', 'md'}
v.g.NERDTreeGitStatusIndicatorMapCustom = {
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
