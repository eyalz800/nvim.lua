local m = {}
local v = require 'vim'

v.g.VM_default_mappings = 0

if v.o.background == 'dark' then
    v.g.VM_theme = 'iceblue'
else
    v.g.VM_theme = 'lightblue1'
end

v.g.VM_leader = 'm'

-- v.g.VM_maps = {
--     ['Find Under'] = 'ms',
--     ['Find Subword Under'] = 'ms',
--     ['Add Cursor At Pos'] = 'mm',
--     ['Start Regex Search'] = 'm/',
--     ['Merge Regions'] = 'mM',
--     ['Toggle Multiline'] = 'mL',
--     ['Select All'] = 'mA',
--     ['Visual All'] = 'mA',
--     ['Visual Add'] = 'ma',
--     ['Visual Cursors'] = 'mc',
--     ['Visual Find'] = 'mf',
--     ['Visual Regex'] = 'm/',
-- }

m.active = false

m.on_visual_multi_start = function()
    m.active = true
end

m.on_visual_multi_exit = function()
    m.active = false
end

return m
