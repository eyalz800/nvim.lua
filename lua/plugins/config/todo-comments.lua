local m = {}

m.setup = function()
    local todo_comments = require 'todo-comments'
    todo_comments.setup(m.config())
    vim.keymap.set('n', ']-', function()
        todo_comments.jump_next()
    end, { desc = 'Next todo comment' })

    vim.keymap.set('n', '[-', function()
        todo_comments.jump_prev()
    end, { desc = 'Previous todo comment' })
end

m.config = function()
    return {
        signs = false,
    }
end

return m
