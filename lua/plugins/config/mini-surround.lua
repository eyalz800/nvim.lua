local m = {}

m.setup = function()
    require 'mini.surround'.setup(m.config())
    vim.keymap.del('x', 'ysa')
    vim.keymap.set('x', 'gsa', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
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
