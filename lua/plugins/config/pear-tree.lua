local m = {}

m.init = function()
    vim.g.pear_tree_pairs = {
        ['('] = { closer = ')' },
        ['['] = { closer = ']' },
        ['{'] = { closer = '}' },
        ["'"] = { closer = "'" },
        ['"'] = { closer = '"' }
    }

    -- Pear Tree is enabled for all filetypes by default:
    vim.g.pear_tree_ft_disabled = {}

    -- Pair expansion is dot-repeatable by default:
    vim.g.pear_tree_repeatable_expand = 0

    -- Smart pairs are disabled by default:
    vim.g.pear_tree_smart_openers = 1
    vim.g.pear_tree_smart_closers = 1
    vim.g.pear_tree_smart_backspace = 1

    -- If enabled, smart pair functions timeout after ms:
    vim.g.pear_tree_timeout = 10

    -- Don't automatically map <BS>, <CR>, and <Esc>
    vim.g.pear_tree_map_special_keys = 0
end

return m
