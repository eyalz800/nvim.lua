local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent
local file_explorer = require 'plugins.file_explorer'

local getwininfo = v.fn.getwininfo
local win_getid = v.fn.win_getid

m.on_open = function()
    local info = getwininfo(win_getid())[1]
    if info.loclist ~= 1 then
        cmd 'wincmd J'
        if file_explorer.is_open() then
            v.defer_fn(function()
                file_explorer.close()
                file_explorer.open({ focus=false })
            end, 0)
        end
    end
end

return m
