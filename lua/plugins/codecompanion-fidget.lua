local m = {}

function m:init()
    local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})

    vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "CodeCompanionRequestStarted",
        group = group,
        callback = function(request)
            local handle = m:create_progress_handle(request)
            m:store_progress_handle(request.data.id, handle)
        end,
    })

    vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "CodeCompanionRequestFinished",
        group = group,
        callback = function(request)
            local handle = m:pop_progress_handle(request.data.id)
            if handle then
                m:report_exit_status(handle, request)
                handle:finish()
            end
        end,
    })
end

m.handles = {}

function m:store_progress_handle(id, handle)
    m.handles[id] = handle
end

function m:pop_progress_handle(id)
    local handle = m.handles[id]
    m.handles[id] = nil
    return handle
end

function m:create_progress_handle(request)
    local progress = require("fidget.progress")
    return progress.handle.create({
        title = " Requesting assistance (" .. request.data.strategy .. ")",
        message = "In progress...",
        lsp_client = {
            name = m:llm_role_title(request.data.adapter),
        },
    })
end

function m:llm_role_title(adapter)
    local parts = {}
    table.insert(parts, adapter.formatted_name)
    if adapter.model and adapter.model ~= "" then
        table.insert(parts, "(" .. adapter.model .. ")")
    end
    return table.concat(parts, " ")
end

function m:report_exit_status(handle, request)
    if request.data.status == "success" then
        handle.message = "Completed"
    elseif request.data.status == "error" then
        handle.message = " Error"
    else
        handle.message = "󰜺 Cancelled"
    end
end

return m
