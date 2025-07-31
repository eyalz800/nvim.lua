local m = {}
vim.g.VM_default_mappings = 0

if vim.o.background == 'dark' then
    vim.g.VM_theme = 'iceblue'
else
    vim.g.VM_theme = 'lightblue1'
end

vim.g.VM_leader = 'm'

-- vim.g.VM_maps = {
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
