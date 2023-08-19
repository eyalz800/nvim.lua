local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent
local exists = require 'vim.exists'.exists
local feed_keys = require 'vim.feed_keys'.feed_keys
local mode = v.fn.mode

local timer = v.loop.new_timer()

m.refresh_trigger = function(source, options)
    options = options or {}
    return function()
        timer:stop()

        timer:start(0, 250, v.schedule_wrap(function()
            local current_mode = mode()
            if current_mode == 'n' or current_mode == 'v' then
                if exists ':IndentBlanklineRefresh' then
                    cmd 'IndentBlanklineRefresh'
                end
                timer:stop()
            end
        end))

        if not options.expr then
            feed_keys(source)
        else
            return source
        end
    end
end

return m
