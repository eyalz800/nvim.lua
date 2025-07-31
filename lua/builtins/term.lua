local m = {}
local termopen = vim.fn.termopen
local jobwait = vim.fn.jobwait

m.open = function(command, options)
    local exit_code = nil
    local term = nil

    term = termopen(command, {
        on_exit = function(_, code, _)
            exit_code = code
            if options.on_exit then
                options.on_exit(code)
            end
        end,
    })

    if term <= 0 then
        error('termopen error: ' .. term)
    end

    local join_result = nil

    vim.wait(1000, function()
        join_result = jobwait({term}, 0)[1]
        return join_result >= -1 or (join_result == -3 and exit_code)
    end)

    return {
        join = function()
            if join_result < 0 then
                join_result = jobwait({term})[1]
            end
            if join_result < 0 and not exit_code then
                error('jobwait error: ' .. join_result)
            end
            return exit_code
        end
    }
end

return m
