local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent

local dap = nil
local dapui = nil

local nvim_win_is_valid = v.api.nvim_win_is_valid
local nvim_set_current_win = v.api.nvim_set_current_win
local nvim_win_get_tabpage = v.api.nvim_win_get_tabpage
local nvim_tabpage_get_number = v.api.nvim_tabpage_get_number
local win_getid = v.fn.win_getid
local expand = v.fn.expand
local fs_stat = v.loop.fs_stat

m.debug_win = nil
m.debug_tab = nil
m.debug_tabnr = nil

m.open = function()
    if m.debug_win and nvim_win_is_valid(m.debug_win) then
        nvim_set_current_win(m.debug_win)
        return
    end

    if fs_stat(expand '%') then
        cmd 'tabedit %'
    else
        cmd 'tabnew'
    end

    m.debug_win = win_getid()
    m.debug_tab = nvim_win_get_tabpage(m.debug_win)
    m.debug_tabnr = nvim_tabpage_get_number(m.debug_tab)

    dapui.open()
end

m.close = function()
    dapui.close()

    if m.debug_tab and vim.api.nvim_tabpage_is_valid(m.debug_tab) then
        cmd('tabclose ' .. m.debug_tabnr)
    end

    m.debug_win = nil
    m.debug_tab = nil
    m.debug_tabnr = nil
end

m.setup = function()
    dap.listeners.after.event_initialized['dapui_config'] = function()
        m.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
        -- m.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
        -- m.close()
    end
end

m.config = function()
    dap = require 'dap'
    dapui = require 'dapui'
    return {
        controls = {
            element = "repl",
            enabled = true,
            icons = {
                disconnect = "",
                pause = "",
                play = "",
                run_last = "",
                step_back = "",
                step_into = "",
                step_out = "",
                step_over = "",
                terminate = ""
            }
        },
        element_mappings = {},
        expand_lines = false,
        floating = {
            border = "single",
            mappings = {
                close = { "q", "<esc>" }
            }
        },
        force_buffers = true,
        icons = {
            collapsed = "",
            current_frame = "",
            expanded = ""
        },
        layouts = { {
            elements = { {
                id = "scopes",
                size = 0.25
            }, {
                id = "breakpoints",
                size = 0.25
            }, {
                id = "stacks",
                size = 0.25
            }, {
                id = "watches",
                size = 0.25
            } },
            position = "left",
            size = 40
        }, {
            elements = { {
                id = "repl",
                size = 0.5
            }, {
                id = "console",
                size = 0.5
            } },
            position = "bottom",
            size = 10
        } },
        mappings = {
            edit = "e",
            expand = { "<cr>", "<2-leftmouse>" },
            open = "o",
            remove = "d",
            repl = "r",
            toggle = "t"
        },
        render = {
            indent = 1,
            max_value_lines = 100
        }
    }
end

return m
