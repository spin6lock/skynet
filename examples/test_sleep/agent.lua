local skynet = require "skynet"

skynet.start(function()
    print("agent booted")
    local self = skynet.self()
    skynet.fork(function()
        while true do
            local freq = 200
            for i=1, freq do
                skynet.send(".center", "lua", "count", self, 1)
            end
            skynet.sleep(100)
        end
    end)
end)
