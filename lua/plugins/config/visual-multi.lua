local m = {}
local user = require 'user'
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

m.active = false

m.init = function()
    vim.g.VM_default_mappings = false
    vim.g.VM_silent_exit = true

    if vim.o.background == 'dark' then
        vim.g.VM_theme = 'iceblue'
    else
        vim.g.VM_theme = 'lightblue1'
    end

    vim.g.VM_leader = 'm'

    -- vim.g.VM_maps = {
        --     ['Find Under'] = 'ms',
        --     ['Find Subword Under'] = 'ms',
        --     ['Add Cursor At Pos'] = 'mm',
        --     ['Start Regex Search'] = 'm/',
        --     ['Merge Regions'] = 'mM',
        --     ['Toggle Multiline'] = 'mL',
        --     ['Select All'] = 'mA',
        --     ['Visual All'] = 'mA',
        --     ['Visual Add'] = 'ma',
        --     ['Visual Cursors'] = 'mc',
        --     ['Visual Find'] = 'mf',
        --     ['Visual Regex'] = 'm/',
        -- }
end

m.setup = function()
    local lsp = require 'plugins.lsp'
    local lsp_was_enabled = nil
    if user.settings.lsp == 'coc' then
        autocmd('User',
            {
                pattern = 'visual_multi_start',
                group = augroup('init.lua.visual-multi-start.lsp', {}),
                callback = function()
                    lsp_was_enabled = lsp.is_enabled()
                    lsp.disable()
                end
            })
    end

    autocmd('User',
        {
            pattern = 'visual_multi_exit',
            group = augroup('init.lua.visual-multi-exit.lsp', {}),
            callback = function()
                if lsp_was_enabled then
                    lsp.enable()
                end
            end
        })

    autocmd('User',
        {
            pattern = 'visual_multi_start',
            group = augroup('init.lua.visual-multi-start.state', {}),
            callback = function()
                require 'plugins.config.visual-multi'.on_visual_multi_start()
            end
        })

    autocmd('User',
        {
            pattern = 'visual_multi_exit',
            group = augroup('init.lua.visual-multi-exit.state', {}),
            callback = function()
                require 'plugins.config.visual-multi'.on_visual_multi_exit()
            end
        })

    if user.settings.line == 'lualine' then
        local lualine = require 'lualine'
        autocmd('User',
            {
                pattern = 'visual_multi_start',
                group = augroup('init.lua.visual-multi-start.line', {}),
                callback = function()
                    lualine.hide()
                end
            })
        autocmd('User',
            {
                pattern = 'visual_multi_exit',
                group = augroup('init.lua.visual-multi-exit.line', {}),
                callback = function()
                    lualine.hide({ unhide = true })
                end
            })
    end

end

m.on_visual_multi_start = function()
    m.active = true
end

m.on_visual_multi_exit = function()
    m.active = false
end

return m
