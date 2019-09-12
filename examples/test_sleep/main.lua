local skynet = require "skynet"

local max_agent = 128
skynet.start(function()
    skynet.uniqueservice("center")
    skynet.newservice("debug_console", 8000)
    skynet.newservice("doctor")
    for i=1,max_agent do
        skynet.newservice("agent")
    end
    skynet.error("booted")
    skynet.exit()
end)
