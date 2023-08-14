local m = {}
local v = require 'vim'

m.create = function()
    local lazypath = v.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not v.loop.fs_stat(lazypath) then
        local echo = require 'vim.echo'.echo
        echo ' Installing plugin manager...'
        v.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
        })
        echo ''
    end
    v.opt.rtp:prepend(lazypath)
end

return m
