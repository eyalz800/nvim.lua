local m = {}
local v = require 'vim'

v.g['sneak#use_ic_scs'] = 1
v.g['sneak#s_next'] = 0
v.g['sneak#label'] = 1

m.search_jump = '<plug>Sneak_s'
m.search_jump_back = '<plug>Sneak_S'
m.find_jump = '<plug>Sneak_f'
m.find_jump_back = '<plug>Sneak_F'
m.till_jump = '<plug>Sneak_t'
m.till_jump_back = '<plug>Sneak_T'

return m
