local m = {}
local cmd = require 'vim.cmd'.silent

m.toggle_zoom = function()
    cmd 'ZoomWinTabToggle'
end

return m

