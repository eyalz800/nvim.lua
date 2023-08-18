local m = {}

local sneak = require 'plugins.config.sneak'
local easymotion = require 'plugins.config.easymotion'

m.search_jump = easymotion.search_jump
m.search_jump_back = easymotion.search_jump_back
m.search_jump_visual = easymotion.search_jump_visual
m.search_jump_back_visual = easymotion.search_jump_back_visual
m.find_jump = sneak.find_jump
m.find_jump_back = sneak.find_jump_back
m.till_jump = sneak.till_jump
m.till_jump_back = sneak.till_jump_back

return m
