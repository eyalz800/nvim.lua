local m = {}
local user = require 'user'

m.setup = function()
    local border = function(hl_name)
        return {
            { "╭", hl_name },
            { "─", hl_name },
            { "╮", hl_name },
            { "│", hl_name },
            { "╯", hl_name },
            { "─", hl_name },
            { "╰", hl_name },
            { "│", hl_name },
        }
    end

    if not user.settings.lsp_config.nvim.completion_border then
        border = function() return false end
    end

    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    require('luasnip.loaders.from_vscode').lazy_load()
    luasnip.config.setup {}

---@diagnostic disable-next-line: missing-fields
    cmp.setup {
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert {
            ['<c-n>'] = cmp.mapping.select_next_item(),
            ['<c-p>'] = cmp.mapping.select_prev_item(),
            ['<c-u>'] = cmp.mapping.scroll_docs(-4),
            ['<c-d>'] = cmp.mapping.scroll_docs(4),
            ['<cr>'] = cmp.mapping.confirm { select = false },
            ['<tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_locally_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<s-tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.locally_jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { 'i', 's' }),
        },
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'buffer' },
            { name = 'nvim_lua' },
            { name = 'path' },
        }),
        view = {
        },
        window = {
            completion = {
                border = border 'Pmenu',
            },
            documentation = {
                border = border 'Pmenu',
            },
        },
        preselect = cmp.PreselectMode.None,
    }
end

return m
