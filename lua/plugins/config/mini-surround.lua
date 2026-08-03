local m = {}

m.setup = function()
    require 'mini.surround'.setup(m.config())

    -- Remap the visual mode add/find mappings from ys* to gs* so that y in visual
    -- mode stays responsive and does not wait for a possible surround mapping.
    local remap_visual = function(old_lhs, new_lhs)
        local map = vim.fn.maparg(old_lhs, 'x', false, true)
        vim.keymap.del('x', old_lhs)
        vim.keymap.set('x', new_lhs, map.callback or map.rhs,
            { expr = map.expr == 1, silent = true, desc = map.desc })
    end

    remap_visual('ysa', 'gsa')
    remap_visual('ysf', 'gsf')
    remap_visual('ysfl', 'gsfl')
    remap_visual('ysfn', 'gsfn')
    remap_visual('ysF', 'gsF')
    remap_visual('ysFl', 'gsFl')
    remap_visual('ysFn', 'gsFn')
end

m.config = function()
    return {
        -- Add custom surroundings to be used on top of builtin ones. For more
        -- information with examples, see `:h MiniSurround.config`.
        custom_surroundings = nil,

        -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
        highlight_duration = 500,

        mappings = {
            add = 'ysa',            -- Add surrounding in Normal and Visual modes
            delete = 'ysd',         -- Delete surrounding
            find = 'ysf',           -- Find surrounding (to the right)
            find_left = 'ysF',      -- Find surrounding (to the left)
            highlight = 'ysh',      -- Highlight surrounding
            replace = 'ysr',        -- Replace surrounding
            update_n_lines = 'ysn', -- Update `n_lines`

            suffix_last = 'l',      -- Suffix to search with "prev" method
            suffix_next = 'n',      -- Suffix to search with "next" method
        },

        -- Number of lines within which surrounding is searched
        n_lines = 20,

        -- Whether to respect selection type:
        -- - Place surroundings on separate lines in linewise mode.
        -- - Place surroundings on each line in blockwise mode.
        respect_selection_type = false,

        -- How to search for surrounding (first inside current line, then inside
        -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
        -- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
        -- see `:h MiniSurround.config`.
        search_method = 'cover',

        -- Whether to disable showing non-error feedback
        -- This also affects (purely informational) helper messages shown after
        -- idle time if user input is required.
        silent = false,
    }
end

return m
