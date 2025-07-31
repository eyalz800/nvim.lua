local m = {}
local cmd = require 'vim.cmd'.silent
local user = require 'user'

m.setup = function()
    require 'neo-zoom'.setup(m.config())
end

m.toggle_zoom = function()
    if user.settings.edge == 'edgy' then
        if vim.b.edgy_disable then
            vim.b.edgy_disable = false
        else
            vim.b.edgy_disable = true
        end
    end
    cmd 'NeoZoomToggle'
end

m.config = function()
    return {
      popup = { enabled = false }, -- this is the default.
      -- NOTE: Add popup-effect (replace the window on-zoom with a `[No Name]`).
      -- EXPLAIN: This improves the performance, and you won't see two
      --          identical buffers got updated at the same time.
      -- popup = {
      --   enabled = true,
      --   exclude_filetypes = {},
      --   exclude_buftypes = {},
      -- },
      exclude_buftypes = { 'terminal' },
      -- exclude_filetypes = { 'lspinfo', 'mason', 'lazy', 'fzf', 'qf' },
      winopts = {
        offset = {
          -- NOTE: omit `top`/`left` to center the floating window vertically/horizontally.
          -- top = 0,
          -- left = 0.17,
          width = 150,
          height = 0.85,
        },
        -- NOTE: check :help nvim_open_win() for possible border values.
        border = 'thicc', -- this is a preset, try it :)
      },
      presets = {
        {
          -- NOTE: regex pattern can be used here!
          filetypes = { 'dapui_.*', 'dap-repl' },
          winopts = {
            offset = { top = 0.02, left = 0.26, width = 0.74, height = 0.25 },
          },
        },
        {
          filetypes = { 'markdown' },
          callbacks = {
            function () vim.wo.wrap = true end,
          },
        },
      },
    }
end

return m
