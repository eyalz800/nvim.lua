local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent
local user = require 'user'
local file_readable = require 'vim.file_readable'.file_readable
local expand = v.fn.expand

local width = 30

m.open = function(options)
    options = options or { focus=true }
    if file_readable(expand('%')) then
        cmd 'NvimTreeFindFile'
    else
        cmd 'NvimTreeOpen'
    end
    if not options.focus then
        cmd 'wincmd w'
    end
end

m.open_current_directory = function()
    cmd 'NvimTreeRefresh'
    cmd('NvimTreeResize ' .. width)
end

m.is_open = function()
    return require 'nvim-tree.view'.is_visible()
end

m.toggle = function()
    cmd 'NvimTreeToggle'
end

m.close = function()
    cmd 'NvimTreeClose'
end

m.options = {
    disable_netrw = true,
    hijack_netrw = true,
    hijack_cursor = true,
    hijack_unnamed_buffer_when_opening = false,
    sync_root_with_cwd = true,
    update_focused_file = {
        enable = true,
        update_root = false,
    },
    view = {
        adaptive_size = false,
        side = "left",
        width = width,
        preserve_window_proportions = true,
    },
    git = {
        enable = true,
        ignore = false,
    },
    filesystem_watchers = {
        enable = true,
    },
    actions = {
        open_file = {
            resize_window = false,
            window_picker = {
                enable = user.settings.file_explorer_config.nvim_tree.window_picker,
            }
        },
    },
    renderer = {
        root_folder_label = false,
        highlight_git = false,
        highlight_opened_files = "none",

        indent_markers = {
            enable = true,
        },

        icons = {
            git_placement = "after",

            show = {
                file = true,
                folder = true,
                folder_arrow = false,
                git = true,
            },

            glyphs = {
                default = "󰈚",
                symlink = "",
                bookmark = "",
                folder = {
                    default = "",
                    empty = "",
                    empty_open = "",
                    open = "",
                    symlink = "",
                    symlink_open = "",
                    arrow_open = "",
                    arrow_closed = "",
                },
                git = {
                    unstaged = "",
                    staged = "󰄬",
                    unmerged = "",
                    renamed = "",
                    untracked = "",
                    deleted = "",
                    ignored = "◌",
                },
            },
        },
    },
}

return m
