local m = {}
local v = require 'vim'

v.g.EasyMotion_do_mapping = 0
v.g.EasyMotion_smartcase = 1

m.search_jump = '<plug>(easymotion-overwin-f2)'
m.search_jump_visual = '<plug>(easymotion-f2)'
m.search_jump_back_visual = '<plug>(easymotion-f2)'

return m
