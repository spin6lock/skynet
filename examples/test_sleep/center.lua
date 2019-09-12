local skynet = require "skynet"
require "skynet.manager"

local command = {}

local db = {}
function command.count(key, value)
    db[key] = (db[key] or 0) + value
end

skynet.start(function()
    skynet.dispatch("lua", function(session, address, cmd, ...)
        local f = assert(command[cmd], cmd)
        skynet.retpack(f(...))
    end)
    skynet.fork(
        function()
            while true do
                print("===============")
                local sum = 0
                for k, v in pairs(db) do
                    sum = sum + v
                end
                print("sum:", sum)
                skynet.sleep(5 * 100) -- 5 seconds
            end
        end
    )
    skynet.register(".center")
end)
