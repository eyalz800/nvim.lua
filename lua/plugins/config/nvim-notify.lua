local m = {}

m.setup = function()
    require 'notify'.setup(m.config())
end

m.config = function()
    return {
        timeout = 1000,
        stages = 'fade_in_slide_out',
    }
end

return m

