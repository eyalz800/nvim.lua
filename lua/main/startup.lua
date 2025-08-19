local m = {}

m.setup = function()
    if vim.env.NVIM_PROFILE then
        local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
        vim.opt.rtp:append(snacks)
        local ok, profiler = pcall(require,  'snacks.profiler')
        if ok then
            profiler.startup({
                startup = {
                    event = vim.env.NVIM_PROFILE_EVENT or 'VimEnter',
                },
            })
        end
    end
end

return m
