local m = {}
local v = require 'vim'

v.cmd [=[

let g:VM_default_mappings = 0

if &background == 'dark'
    let g:VM_theme = 'iceblue'
else
    let g:VM_theme = 'lightblue1'
endif

let g:VM_leader = '<leader>m'

let g:VM_maps = {
    \ 'Find Under': '<leader>ms',
    \ 'Find Subword Under': '<leader>ms',
    \ 'Add Cursor At Pos': '<leader>mm',
    \ 'Start Regex Search': 'm/',
    \ 'Merge Regions': '<leader>mM',
    \ 'Toggle Multiline': '<leader>mL',
    \ 'Select All': '<leader>mA',
    \ 'Visual All': '<leader>mA',
    \ 'Visual Add': '<leader>ma',
    \ 'Visual Cursors': '<leader>mc',
    \ 'Visual Find': '<leader>mf',
    \ 'Visual Regex': '<leader>m/',
\ }

]=]

return m
