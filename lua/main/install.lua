local m = {}
local file_readable = require 'vim.file_readable'.file_readable
local cmd = require 'vim.cmd'.silent
local term = require 'builtins.term'
local os = require 'lib.os'.os
local echo = require 'vim.echo'.echo
local system = vim.fn.system
local schedule = vim.schedule
local stdpath = vim.fn.stdpath

m.install_status_dir = stdpath('config') .. '/install'

m.installed = function()
    return file_readable(m.install_status_dir .. '/success')
end

m.setup = function(options)
    if m.installed() then
        return
    end

    local co = nil

    co = coroutine.create(function()
        system('mkdir -p ' .. m.install_status_dir)
        local recipe = require 'main.install.recipe'

        for _, command in ipairs(recipe) do
            command.os = command.os or os
            if command.os ~= os then
                goto continue
            end

            if command.cond == nil then
                command.cond = true
            end

            if not command.cond then
                goto continue
            end

            if command.cond ~= true and not command.cond() then
                goto continue
            end

            if file_readable(m.install_status_dir .. '/' .. command.name) then
                goto continue
            end

            echo('(install) ' .. command.name)

            cmd 'enew'
            local timer = vim.loop.new_timer()
            timer:start(0, 1000, vim.schedule_wrap(function()
                if vim.fn.mode() == 'n' then
                    cmd 'normal! G'
                end
            end))

            local command_job = term.open(command.command, {on_exit = function()
                    local status, result = coroutine.resume(co)
                    if not status then
                        error(result)
                    end
                end })

            coroutine.yield()
            timer:stop()

            local exit_code = command_job.join()
            if exit_code ~= 0 then
                error('Installation failed with error: ' .. exit_code .. '.')
            end

            system('touch ' .. m.install_status_dir .. '/' .. command.name)
            ::continue::
        end

        cmd 'enew'
        if options.on_finish then
            options.on_finish()
        end
    end)

    schedule(vim.schedule_wrap(function()
        local status, result = coroutine.resume(co)
        if not status then
            error(result)
        end
    end))
end

m.forget = function()
    system('rm -rf ' .. m.install_status_dir)
end

return m
