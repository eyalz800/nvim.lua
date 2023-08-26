local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent
local user = require 'user'
local bufdelete = require 'bufdelete'.bufdelete

local bufferline = nil

m.next_buffer = function()
    cmd 'BufferLineCycleNext'
end

m.prev_buffer = function()
    cmd 'BufferLineCyclePrev'
end

m.delete_buffer = function(id)
    bufdelete(id or 0, true)
end

m.switch_to_buffer = function(number)
    return '<cmd>BufferLineGoToBuffer ' .. number .. '<cr>'
end

m.config = function()
    bufferline = require 'bufferline'

    v.cmd [=[
        hi! def link InitLuaBufferLineBg Normal
        hi! def link InitLuaBufferLineOffsetSep Pmenu
        hi! def link InitLuaBufferLineSelectedBg Pmenu
        hi! def link InitLuaBufferLineSelectedFg NormalSB
        hi! def link InitLuaBufferLineVisibleFg NonText
        hi! def link InitLuaBufferLineVisibleBg Pmenu
        hi! def link InitLuaBufferLineNormalFg NonText
        hi! def link InitLuaBufferLineNormalBg CursorLine
    ]=]

    local offset_sep = { highlight = "InitLuaBufferLineOffsetSep", attribute = "bg" }
    if user.settings.file_explorer ~= 'nvim-tree' then
        offset_sep = { highlight = "Normal", attribute = "bg" }
    end
    local line_bg = { highlight = "InitLuaBufferLineBg", attribute = "bg" }
    local selected_fg = { highlight = 'InitLuaBufferLineSelectedFg', attribute = "fg" }
    local selected_bg = { highlight = 'InitLuaBufferLineSelectedBg', attribute = "bg" }
    local visible_fg = { highlight = 'InitLuaBufferLineVisibleFg', attribute = "fg" }
    local visible_bg = { highlight = 'InitLuaBufferLineVisibleBg', attribute = "bg" }
    local fg = { highlight = 'InitLuaBufferLineNormalFg', attribute = "fg" }
    local bg = { highlight = "InitLuaBufferLineNormalBg", attribute = "bg" }

    return {
        options = {
            mode = "buffers",
            style_preset = {
                bufferline.style_preset.no_bold,
                bufferline.style_preset.no_italic,
            },
            close_command = m.delete_buffer,
            right_mouse_command = 'vert sbuffer %d',
            indicator = { style = 'none' },
            buffer_close_icon = '󰅖',
            modified_icon = '●',
            close_icon = '',
            left_trunc_marker = '',
            right_trunc_marker = '',
            max_name_length = 18,
            max_prefix_length = 15,
            truncate_names = true,
            tab_size = 10,
            diagnostics_update_in_insert = false,
            separator_style = 'slant',
            sort_by = 'insert_after_current',
            custom_filter = function(bufnr)
                local exclude_ft = { 'qf', 'fugitive', 'git', 'dirvish', 'nerdtree', 'tagbar', 'NvimTree' }
                local cur_ft = v.bo[bufnr].filetype
                local should_show = not v.tbl_contains(exclude_ft, cur_ft)
                should_show = should_show and v.fn.bufname(bufnr) ~= ''
                return should_show
            end,
            offsets = {
                {
                    filetype = 'NvimTree',
                    text = 'File Explorer',
                    text_align = 'left',
                    highlight = 'NvimTreeNormal',
                    separator = true,
                },
                {
                    filetype = 'nerdtree',
                    text = 'File Explorer',
                    text_align = 'left',
                    separator = true,
                },
            },
        },
        highlights = {
            fill = { bg = line_bg },
            offset_separator = { fg = offset_sep, bg = offset_sep},
            separator = { fg = line_bg, bg = bg },
            separator_visible = { fg = line_bg, bg = visible_bg },
            separator_selected = { fg = line_bg, bg = selected_bg },
            trunc_marker = { fg = fg, bg = line_bg },
            background = { fg = fg, bg = bg },
            buffer_visible = { fg = visible_fg, bg = visible_bg },
            buffer_selected = { fg = selected_fg, bg = selected_bg },
            duplicate = { fg = fg, bg = bg },
            duplicate_visible = { fg = visible_fg, bg = visible_bg },
            duplicate_selected = { fg = selected_fg, bg = selected_bg },
            close_button = { fg = fg, bg = bg },
            close_button_visible = { fg = visible_fg, bg = visible_bg },
            close_button_selected = { fg = selected_fg, bg = selected_bg },
            tab = { fg = fg, bg = bg },
            tab_selected = { fg = selected_fg, bg = selected_bg },
            tab_separator = { fg = line_bg, bg = bg },
            tab_separator_selected = { fg = line_bg, bg = selected_bg },
            tab_close = { fg = fg, bg = line_bg },
            numbers = { fg = fg, bg = bg },
            numbers_visible = { fg = visible_fg, bg = visible_bg },
            numbers_selected = { fg = selected_fg, bg = selected_bg },

            modified = { bg = bg },
            modified_visible = { bg = visible_bg },
            modified_selected = { bg = selected_bg },
            pick = { bg = bg },
            pick_visible = { bg = visible_bg },
            pick_selected = { bg = selected_bg },
            indicator_visible = { bg = visible_bg },
            indicator_selected = { bg = selected_bg },

            diagnostic = { bg = bg },
            diagnostic_visible = { bg = visible_bg },
            diagnostic_selected = { bg = selected_bg },
            hint = { bg = bg },
            hint_visible = { bg = visible_bg },
            hint_selected = { bg = selected_bg },
            info = { bg = bg },
            info_visible = { bg = visible_bg },
            info_selected = { bg = selected_bg },
            info_diagnostic = { bg = bg },
            info_diagnostic_visible = { bg = visible_bg },
            info_diagnostic_selected = { bg = selected_bg },
            warning = { bg = bg },
            warning_visible = { bg = visible_bg },
            warning_selected = { bg = selected_bg },
            warning_diagnostic = { bg = bg },
            warning_diagnostic_visible = { bg = visible_bg },
            warning_diagnostic_selected = { bg = selected_bg },
            error = { bg = bg },
            error_visible = { bg = visible_bg },
            error_selected = { bg = selected_bg },
            error_diagnostic = { bg = bg },
            error_diagnostic_visible = { bg = visible_bg },
            error_diagnostic_selected = { bg = selected_bg },
        },
    }
end

return m
