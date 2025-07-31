local m = {}
vim.g['sneak#use_ic_scs'] = 1
vim.g['sneak#s_next'] = 0
vim.g['sneak#label'] = 1

m.search_jump = '<plug>Sneak_s'
m.search_jump_back = '<plug>Sneak_S'
m.find_jump = '<plug>Sneak_f'
m.find_jump_back = '<plug>Sneak_F'
m.till_jump = '<plug>Sneak_t'
m.till_jump_back = '<plug>Sneak_T'

m.search_jump_visual = m.search_jump
m.search_jump_back_visual = m.search_jump_back

return m
