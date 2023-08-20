local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent

local bufferline = nil

m.next_buffer = function()
    cmd 'BufferLineCycleNext'
end

m.prev_buffer = function()
    cmd 'BufferLineCyclePrev'
end

m.delete_buffer = function()
    cmd 'BD'
end

m.config = function()
    bufferline = require 'bufferline'
    return {
        options = {
            mode = "buffers", -- set to "tabs" to only show tabpages instead
            style_preset = bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
            -- numbers = "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
            -- close_command = "bdelete! %d",       -- can be a string | function, | false see "Mouse actions"
            -- right_mouse_command = "bdelete! %d", -- can be a string | function | false, see "Mouse actions"
            right_mouse_command = 'vert sbuffer %d', -- can be a string | function | false, see "Mouse actions"
            indicator = { style = 'none' },
            buffer_close_icon = '󰅖',
            modified_icon = '●',
            close_icon = '',
            left_trunc_marker = '',
            right_trunc_marker = '',
            max_name_length = 18,
            max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
            truncate_names = true, -- whether or not tab names should be truncated
            tab_size = 18,
            diagnostics_update_in_insert = false,
            custom_filter = function(bufnr)
                local exclude_ft = { "qf", "fugitive", "git", "dirvish", 'nerdtree', 'tagbar', 'NvimTree' }
                local cur_ft = v.bo[bufnr].filetype
                local should_show = not v.tbl_contains(exclude_ft, cur_ft)
                should_show = should_show and v.fn.bufname(bufnr) ~= ''
                return should_show
            end,
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "File Explorer",
                    text_align = "left",
                    separator = true,
                },
                {
                    filetype = "nerdtree",
                    text = "File Explorer",
                    text_align = "left",
                    separator = true,
                },
            },
            separator_style = "slant",
            sort_by = 'insert_after_current',
        },
    }
end

return m
