local m = {}
local v = require 'vim'
local user = require 'user'

if user.settings.fidget and user.settings.codecompanion_config.progress == 'fidget' then
    function m:init()
        local group = v.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})

        v.api.nvim_create_autocmd({ "User" }, {
            pattern = "CodeCompanionRequestStarted",
            group = group,
            callback = function(request)
                local handle = m:create_progress_handle(request)
                m:store_progress_handle(request.data.id, handle)
            end,
        })

        v.api.nvim_create_autocmd({ "User" }, {
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
        local strategy = request.data.strategy or 'none'
        local adapter = request.data.adapter or 'none'
        return progress.handle.create({
            title = " Requesting assistance (" .. strategy .. ")",
            message = "In progress...",
            lsp_client = {
                name = m:llm_role_title(adapter),
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
elseif user.settings.noice and user.settings.codecompanion_config.progress == 'noice' then
    local format = require("noice.text.format")
    local message = require("noice.message")
    local manager = require("noice.message.manager")
    local router = require("noice.message.router")

    local throttle_time = 200

    m.handles = {}
    function m.init()
        local group = v.api.nvim_create_augroup("NoiceCompanionRequests", {})

        v.api.nvim_create_autocmd({ "User" }, {
            pattern = "CodeCompanionRequestStarted",
            group = group,
            callback = function(request)
                local handle = m.create_progress_message(request)
                m.store_progress_handle(request.data.id, handle)
                m.update(handle)
            end,
        })

        v.api.nvim_create_autocmd({ "User" }, {
            pattern = "CodeCompanionRequestFinished",
            group = group,
            callback = function(request)
                local message = m.pop_progress_message(request.data.id)
                if message then
                    message.opts.progress.message = m.report_exit_status(request)
                    m.finish_progress_message(message)
                end
            end,
        })
    end

    function m.store_progress_handle(id, handle)
        m.handles[id] = handle
    end

    function m.pop_progress_message(id)
        local handle = m.handles[id]
        m.handles[id] = nil
        return handle
    end

    function m.create_progress_message(request)
        local msg = message("lsp", "progress")
        local id = request.data.id
        msg.opts.progress = {
            client_id = "client " .. id,
            client = m.llm_role_title(request.data.adapter),
            id = id,
            message = "Awaiting Response: ",
        }
        return msg
    end

    function m.update(message)
        if m.handles[message.opts.progress.id] then
            manager.add(format.format(message, "lsp_progress"))
            v.defer_fn(function()
                m.update(message)
            end, throttle_time)
        end
    end

    function m.finish_progress_message(message)
        manager.add(format.format(message, "lsp_progress"))
        router.update()
        manager.remove(message)
    end

    function m.llm_role_title(adapter)
        local parts = {}
        table.insert(parts, adapter.formatted_name)
        if adapter.model and adapter.model ~= "" then
            table.insert(parts, "(" .. adapter.model .. ")")
        end
        return table.concat(parts, " ")
    end

    function m.report_exit_status(request)
        if request.data.status == "success" then
            return "Completed"
        elseif request.data.status == "error" then
            return " Error"
        else
            return "󰜺 Cancelled"
        end
    end
else
    m.init = function()
        -- No progress tracking
    end
end

return m
