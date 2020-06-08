local skynet = require "skynet"


skynet.start(function()
	print("Main Server start")
	local console = skynet.newservice(
		"testmongodb_performance", "127.0.0.1", 27017, "testdb"
	)
	
	print("Main Server exit")
	skynet.exit()
end)
