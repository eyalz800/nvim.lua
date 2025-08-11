local m = {}
m.create = function()
    local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
    if not vim.loop.fs_stat(lazypath) then
        local echo = require 'vim.echo'.echo
        echo ' Installing plugin manager...'
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
        })
        echo ''
    end
    vim.opt.rtp:prepend(lazypath)
end

return m
