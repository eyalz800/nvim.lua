local m = {}
local v = require 'vim'

v.g.pear_tree_pairs = {
    ['('] = { closer = ')' },
    ['['] = { closer = ']' },
    ['{'] = { closer = '}' },
    ["'"] = { closer = "'" },
    ['"'] = { closer = '"' }
}

-- Pear Tree is enabled for all filetypes by default:
v.g.pear_tree_ft_disabled = {}

-- Pair expansion is dot-repeatable by default:
v.g.pear_tree_repeatable_expand = 0

-- Smart pairs are disabled by default:
v.g.pear_tree_smart_openers = 1
v.g.pear_tree_smart_closers = 1
v.g.pear_tree_smart_backspace = 1

-- If enabled, smart pair functions timeout after ms:
v.g.pear_tree_timeout = 10

-- Don't automatically map <BS>, <CR>, and <Esc>
v.g.pear_tree_map_special_keys = 0

return m
