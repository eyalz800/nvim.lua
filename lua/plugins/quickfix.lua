local m = {}
local cmd = require 'vim.cmd'.silent
local explorers = require 'plugins.explorers'
local user = require 'user'
local terminal = require 'plugins.terminal'

local win_getid = vim.fn.win_getid
local win_gotoid = vim.fn.win_gotoid
local getqflist = vim.fn.getqflist
local quickfix_winhls = {
    none = nil,
    ['edge-window'] = 'EndOfBuffer:NvimTreeEndOfBuffer,CursorLine:NvimTreeCursorLine,CursorLineNr:NvimTreeCursorLineNr,LineNr:NvimTreeLineNr,WinSeparator:NvimTreeWinSeparator,StatusLine:NvimTreeStatusLine,StatusLineNC:NvimTreeStatuslineNC,SignColumn:NvimTreeSignColumn,Normal:NvimTreeNormal,NormalNC:NvimTreeNormalNC,NormalFloat:NvimTreeNormalFloat,FloatBorder:NvimTreeNormalFloatBorder',
}
local quickfix_winhl = quickfix_winhls[user.settings.quickfix_config.winhl or 'none']

m.open = function(options)
    options = options or {}

    local return_win = win_getid()

    local qf_winid = getqflist({ winid = 0 }).winid
    if qf_winid > 0 then
        if options.focus then
            win_gotoid(qf_winid)
        end
        return
    end

    cmd 'below copen'

    if options.focus == false then
        win_gotoid(return_win)
    end

    if options.expand and user.settings.quickfix_expand then
        explorers.arrange()
    end
end

m.map_open = function()
    m.open({ focus = true, expand = true })
end

m.on_open = function()
    vim.o.relativenumber = false
    vim.keymap.set('n', 'q', ':<C-u>q<cr>', { silent=true, buffer=true })
    vim.keymap.set('n', 'a', explorers.arrange, { silent=true, buffer=true })
    vim.keymap.set('n', 'C', terminal.open_below, { silent = true, buffer = true })

    if quickfix_winhl and #vim.opt_local.winhighlight == 0 then
        vim.opt_local.winhighlight = quickfix_winhl
    end
end

return m
