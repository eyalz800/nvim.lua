local m = {}
local v = require 'vim'
local user = require 'user'

local file_readable = require 'vim.file_readable'.file_readable
local cmd = require 'vim.cmd'.silent

local expand = v.fn.expand
local getcwd = v.fn.getcwd

local width = 30

m.open = function(options)
    options = options or { focus=true }
    if file_readable(expand '%') then
        cmd 'NvimTreeFindFile'
    else
        cmd 'NvimTreeOpen'
    end
    if not options.focus then
        cmd 'wincmd p'
    end
end

m.open_current_directory = function()
    cmd 'NvimTreeRefresh'
    cmd('NvimTreeResize ' .. width)
end

m.is_open = function()
    return require 'nvim-tree.api'.tree.is_visible()
end

m.toggle = function()
    cmd 'NvimTreeToggle'
end

m.close = function()
    cmd 'NvimTreeClose'
end

m.config = function()
    return {
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
            enable = v.loop.fs_stat('/mnt/c/Windows') == nil,
        },
        actions = {
            open_file = {
                resize_window = true,
                eject = not user.settings.pin_bars,
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
        on_attach = function(bufnr)
            local api = require 'nvim-tree.api'
            local map = vim.keymap.set
            local opts = function(desc)
                return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end

            local change_root_to_node = function()
                api.tree.change_root_to_node()
                cmd('cd ' .. getcwd())
            end

            map('n', '<c-]>', change_root_to_node, opts('CD'))
            map('n', '<c-e>', api.node.open.replace_tree_buffer, opts('Open: In Place'))
            map('n', '<c-k>', api.node.show_info_popup, opts('Info'))
            map('n', '<c-r>', api.fs.rename_sub, opts('Rename: Omit Filename'))
            map('n', '<c-t>', api.node.open.tab, opts('Open: New Tab'))
            map('n', '<c-s>', api.node.open.vertical, opts('Open: Vertical Split'))
            map('n', '<c-x>', api.node.open.horizontal, opts('Open: Horizontal Split'))
            map('n', '<bs>', api.node.navigate.parent_close, opts('Close Directory'))
            map('n', '<cr>', api.node.open.edit, opts('Open'))
            map('n', '<tab>', api.node.open.preview, opts('Open Preview'))
            map('n', '>', api.node.navigate.sibling.next, opts('Next Sibling'))
            map('n', '<', api.node.navigate.sibling.prev, opts('Previous Sibling'))
            map('n', '.', api.node.run.cmd, opts('Run Command'))
            map('n', '-', api.tree.change_root_to_parent, opts('Up'))
            map('n', 'a', api.fs.create, opts('Create'))
            map('n', 'bd', api.marks.bulk.delete, opts('Delete Bookmarked'))
            map('n', 'bmv', api.marks.bulk.move, opts('Move Bookmarked'))
            map('n', 'B', api.tree.toggle_no_buffer_filter, opts('Toggle Filter: No Buffer'))
            map('n', 'c', api.fs.copy.node, opts('Copy'))
            map('n', 'C', api.tree.toggle_git_clean_filter, opts('Toggle Filter: Git Clean'))
            map('n', '[c', api.node.navigate.git.prev, opts('Prev Git'))
            map('n', ']c', api.node.navigate.git.next, opts('Next Git'))
            map('n', 'd', api.fs.remove, opts('Delete'))
            map('n', 'D', api.fs.trash, opts('Trash'))
            map('n', 'E', api.tree.expand_all, opts('Expand All'))
            map('n', 'e', api.fs.rename_basename, opts('Rename: Basename'))
            map('n', ']e', api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
            map('n', '[e', api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))
            map('n', 'F', api.live_filter.clear, opts('Clean Filter'))
            map('n', 'f', api.live_filter.start, opts('Filter'))
            map('n', 'g?', api.tree.toggle_help, opts('Help'))
            map('n', 'gy', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
            map('n', '<leader>h', api.tree.toggle_hidden_filter, opts('Toggle Filter: Dotfiles'))
            map('n', 'I', api.tree.toggle_gitignore_filter, opts('Toggle Filter: Git Ignore'))
            map('n', 'J', api.node.navigate.sibling.last, opts('Last Sibling'))
            map('n', 'K', api.node.navigate.sibling.first, opts('First Sibling'))
            map('n', 'm', api.marks.toggle, opts('Toggle Bookmark'))
            map('n', 'o', api.node.open.edit, opts('Open'))
            map('n', 'O', api.node.open.no_window_picker, opts('Open: No Window Picker'))
            map('n', 'p', api.fs.paste, opts('Paste'))
            map('n', 'P', api.node.navigate.parent, opts('Parent Directory'))
            map('n', 'q', api.tree.close, opts('Close'))
            map('n', 'r', api.fs.rename, opts('Rename'))
            map('n', 'R', api.tree.reload, opts('Refresh'))
            map('n', 's', api.node.run.system, opts('Run System'))
            map('n', 'S', api.tree.search_node, opts('Search'))
            map('n', 'U', api.tree.toggle_custom_filter, opts('Toggle Filter: Hidden'))
            map('n', 'W', api.tree.collapse_all, opts('Collapse'))
            map('n', 'x', api.fs.cut, opts('Cut'))
            map('n', 'y', api.fs.copy.filename, opts('Copy Name'))
            map('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path'))
            map('n', '<2-LeftMouse>', api.node.open.edit, opts('Open'))
            map('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
        end
    }
end

return m
