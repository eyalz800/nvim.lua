local m = {}
local v = require 'vim'
local user = require 'user'

local nvim_get_hl = v.api.nvim_get_hl
local nvim_set_hl = v.api.nvim_set_hl

m.config = function()
    require 'plugins.colors'.subscribe(m.on_color)
    m.on_color()

    local min_width = 30
    return {
        left = {
            {
                title = "File Explorer",
                ft = "NvimTree",
                pinned = true,
                open = "NvimTreeOpen",
            },
            {
                title = "Symbols",
                ft = "Outline",
                pinned = true,
                open = require 'plugins.code_explorer'.open,
            },
        },
        bottom = {
            {
                ft = "qf",
                title = "QuickFix"
            },
        },
        right = {
            {
                title = "Help",
                ft = "help",
                size = { width = 0.5 },
                filter = function(buf)
                    return v.bo[buf].buftype == "help"
                end,
            },
        },

        top = {},

        ---@type table<Edgy.Pos, {size:integer | fun():integer, wo?:vim.wo}>
        options = {
            left = { size = min_width },
            bottom = { size = 10 },
            right = { size = min_width },
            top = { size = 10 },
        },
        -- edgebar animations
        animate = {
            enabled = false,
            fps = 100, -- frames per second
            cps = 120, -- cells per second
            on_begin = function()
                v.g.minianimate_disable = true
            end,
            on_end = function()
                v.g.minianimate_disable = false
            end,
            -- Spinner for pinned views that are loading.
            -- if you have noice.nvim installed, you can use any spinner from it, like:
            -- spinner = require("noice.util.spinners").spinners.circleFull,
            spinner = {
                frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
                interval = 80,
            },
        },
        -- enable this to exit Neovim when only edgy windows are left
        exit_when_last = false,
        -- close edgy when all windows are hidden instead of opening one of them
        -- disable to always keep at least one edgy split visible in each open section
        close_when_all_hidden = false,
        -- global window options for edgebar windows
        ---@type vim.wo
        wo = {
            -- Setting to `true`, will add an edgy winbar.
            -- Setting to `false`, won't set any winbar.
            -- Setting to a string, will set the winbar to that string.
            winbar = true,
            winfixwidth = true,
            winfixheight = false,
            winhighlight = 'WinSeparator:EdgyWinSeparator,EndOfBuffer:EdgyEndOfBuffer',
            --     "EdgyWinBar:Pmenu," ..
            --     "WinSeparator:NvimTreeWinSeparator," ..
            --     "EdgyNormal:Pmenu," ..
            --     "EdgyTitle:Pmenu," ..
            --     "EdgyIcon:Pmenu," ..
            --     "EdgyIconActive:Pmenu," ..
            --     "WinBar:EdgyWinBar," ..
            --     "Normal:EdgyNormal," ..
            --     "",
            signcolumn = "no",
        },
        -- buffer-local keymaps to be added to edgebar buffers.
        -- Existing buffer-local keymaps will never be overridden.
        -- Set to false to disable a builtin.
        ---@type table<string, fun(win:Edgy.Window)|false>
        keys = {
            -- close window
            ["q"] = function(win)
                win:close()
            end,
            -- hide window
            ["<c-q>"] = function(win)
                win:hide()
            end,
            -- close sidebar
            ["Q"] = function(win)
                win.view.edgebar:close()
            end,
            -- next open window
            ["]w"] = function(win)
                win:next({ visible = true, focus = true })
            end,
            -- previous open window
            ["[w"] = function(win)
                win:prev({ visible = true, focus = true })
            end,
            -- next loaded window
            ["]W"] = function(win)
                win:next({ pinned = false, focus = true })
            end,
            -- prev loaded window
            ["[W"] = function(win)
                win:prev({ pinned = false, focus = true })
            end,
            -- increase width
            ["<c-w>>"] = function(win)
                win:resize("width", 2)
            end,
            -- decrease width
            ["<c-w><lt>"] = function(win)
                win:resize("width", -2)
            end,
            -- increase height
            ["<c-w>+"] = function(win)
                win:resize("height", 2)
            end,
            -- decrease height
            ["<c-w>-"] = function(win)
                win:resize("height", -2)
            end,
            -- reset all custom sizing
            ["<c-w>="] = function(win)
                win.view.edgebar:equalize()
            end,
            ["L"] = function(win)
                if win.view.edgebar.pos == 'left' then
                    win:resize("width", 2)
                elseif win.view.edgebar.bounds.width > min_width then
                    win:resize("width", -2)
                end
            end,
            ["H"] = function(win)
                if win.view.edgebar.pos == 'right' then
                    win:resize("width", 2)
                elseif win.view.edgebar.bounds.width > min_width then
                    win:resize("width", -2)
                end
            end,
        },
        icons = {
            closed = "",
            open = "",
        },
      fix_win_height = v.fn.has("nvim-0.10.0") == 0,
    }
end

m.on_color = function()
    local bg = nvim_get_hl(0, { name = 'StatusLine' }).bg
    if user.settings.file_explorer == 'nvim-tree' then
        bg = nvim_get_hl(0, { name = 'NvimTreeNormal' }).bg
    end
    local sign = nvim_get_hl(0, { name = 'SignColumn' })
    local title = nvim_get_hl(0, { name = 'Title' })
    local constant = nvim_get_hl(0, { name = 'Constant' })
    local normal = nvim_get_hl(0, { name = 'Normal' })
    nvim_set_hl(0, "EdgyIcon", { fg = sign.fg, bg = bg, link = nil })
    nvim_set_hl(0, "EdgyIconActive", { fg = constant.fg, bg = bg, link = nil })
    nvim_set_hl(0, "EdgyTitle", { fg = title.fg, bg = bg, link = nil })
    nvim_set_hl(0, "EdgyWinBar", { fg = bg, bg = bg, link = nil })
    nvim_set_hl(0, "EdgyWinSeparator", { fg = bg, bg = bg, link = nil })
    nvim_set_hl(0, "EdgyNormal", { fg = normal.fg, bg = bg, link = nil })
    nvim_set_hl(0, "WinBar", { fg = normal.fg, bg = bg })
    nvim_set_hl(0, "EdgyEndOfBuffer", { fg = bg, bg = bg })
end

return m
