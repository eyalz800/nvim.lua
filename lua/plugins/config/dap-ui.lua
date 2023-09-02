local m = {}
local v = require 'vim'
local cmd = require 'vim.cmd'.silent
local user = require 'user'

local dap = nil
m.dapui = nil

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

    m.dapui.open({ reset = true })
end

m.close = function()
    m.dapui.close()

    if m.debug_tab and vim.api.nvim_tabpage_is_valid(m.debug_tab) then
        cmd('tabclose ' .. m.debug_tabnr)
    end

    m.debug_win = nil
    m.debug_tab = nil
    m.debug_tabnr = nil
end

m.setup = function()
    require 'plugins.colors'.subscribe(m.on_color)
    m.on_color()
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

m.on_color = function()
    local success, hl = pcall(require, 'dapui.config.highlights')
    if success then
        pcall(hl.setup)
    end

    local nvim_get_hl = v.api.nvim_get_hl
    local nvim_set_hl = v.api.nvim_set_hl

    local bg = nvim_get_hl(0, { name = 'WinBar' }).bg
    nvim_set_hl(0, 'DapUIStepOver', { fg = nvim_get_hl(0, { name = 'DapUIStepOver' }).fg, bg = bg })
    nvim_set_hl(0, 'DapUIStepInto', { fg = nvim_get_hl(0, { name = 'DapUIStepInto' }).fg, bg = bg })
    nvim_set_hl(0, 'DapUIStepBack', { fg = nvim_get_hl(0, { name = 'DapUIStepBack' }).fg, bg = bg })
    nvim_set_hl(0, 'DapUIStepOut', { fg = nvim_get_hl(0, { name = 'DapUIStepOut' }).fg, bg = bg })
    nvim_set_hl(0, 'DapUIStop', { fg = nvim_get_hl(0, { name = 'DapUIStop' }).fg, bg = bg })
    nvim_set_hl(0, 'DapUIPlayPause', { fg = nvim_get_hl(0, { name = 'DapUIPlayPause' }).fg, bg = bg })
    nvim_set_hl(0, 'DapUIRestart', { fg = nvim_get_hl(0, { name = 'DapUIRestart' }).fg, bg = bg })
    nvim_set_hl(0, 'DapUIUnavailable', { fg = nvim_get_hl(0, { name = 'DapUIUnavailable' }).fg, bg = bg })

    nvim_set_hl(0, 'DapUIStepOverNC', { fg = nvim_get_hl(0, { name = 'DapUIStepOverNC' }).fg, bg = bg })
    nvim_set_hl(0, 'DapUIStepIntoNC', { fg = nvim_get_hl(0, { name = 'DapUIStepIntoNC' }).fg, bg = bg })
    nvim_set_hl(0, 'DapUIStepBackNC', { fg = nvim_get_hl(0, { name = 'DapUIStepBackNC' }).fg, bg = bg })
    nvim_set_hl(0, 'DapUIStepOutNC', { fg = nvim_get_hl(0, { name = 'DapUIStepOutNC' }).fg, bg = bg })
    nvim_set_hl(0, 'DapUIStopNC', { fg = nvim_get_hl(0, { name = 'DapUIStopNC' }).fg, bg = bg })
    nvim_set_hl(0, 'DapUIPlayPauseNC', { fg = nvim_get_hl(0, { name = 'DapUIPlayPauseNC' }).fg, bg = bg })
    nvim_set_hl(0, 'DapUIRestartNC', { fg = nvim_get_hl(0, { name = 'DapUIRestartNC' }).fg, bg = bg })
    nvim_set_hl(0, 'DapUIUnavailableNC', { fg = nvim_get_hl(0, { name = 'DapUIUnavailableNC' }).fg, bg = bg })
end

m.config = function()
    dap = require 'dap'
    m.dapui = require 'dapui'
    return {
        controls = {
            element = 'repl',
            enabled = true,
            icons = {
                disconnect = '',
                pause = '',
                play = '',
                run_last = '',
                step_back = '',
                step_into = '',
                step_out = '',
                step_over = '',
                terminate = ''
            }
        },
        element_mappings = {
            stacks = {
                open = { 'o', '<cr>', '<2-leftmouse>' },
                expand = { 'E' },
            }
        },
        expand_lines = false,
        floating = {
            border = 'single',
            mappings = {
                close = { 'q', '<esc>' }
            }
        },
        force_buffers = true,
        icons = {
            collapsed = '',
            current_frame = '',
            expanded = ''
        },
        layouts = { {
            elements = { {
                id = 'breakpoints',
                size = 0.15
            }, {
                id = 'stacks',
                size = 0.25
            }, {
                id = 'scopes',
                size = 0.45
            }, {
                id = 'watches',
                size = 0.15
            }, },
            position = 'left',
            size = 40
        }, {
            elements = { {
                id = 'console',
                size = 0.4
            }, {
                id = 'repl',
                size = 0.6
            }, },
            position = 'bottom',
            size = 10
        }, },
        mappings = {
            edit = 'e',
            expand = { '<cr>', '<2-leftmouse>' },
            open = 'o',
            remove = 'd',
            repl = 'r',
            toggle = 't'
        },
        render = {
            indent = 1,
            max_value_lines = 100
        }
    }
end

return m
