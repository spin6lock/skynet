local skynet = require "skynet"
local mongo = require "skynet.db.mongo"
local bson = require "bson"

local host, port, db_name, username, password = ...
if port then
	port = math.tointeger(port)
end

-- print(host, port, db_name, username, password)

local function _create_client()
	return mongo.client(
		{
			host = host, port = port,
			username = username, password = password,
			authdb = db_name,
		}
	)
end

local tinsert = table.insert
local function gen_str(size)
    local ret = {}
    for i=1,size do
        tinsert(ret, "@")
    end
    return table.concat(ret, '')
end

local SIZE = 10000
local long_str = gen_str(1000)
function test_insert()
	local db = _create_client()
	db[db_name].testdb:dropIndex("*")
	db[db_name].testdb:drop()
    local begin = os.clock()
	db[db_name].testdb:ensureIndex({test_key = 1}, {test_key2 = -1}, {unique = true, name = "test_index"})
    for i=1, SIZE do
        local ok, err, ret = db[db_name].testdb:safe_insert({test_key = i, test_key2 = i, padding=long_str})
    end
    local finish = os.clock()
    local cost = finish - begin
    local per_cost = cost / SIZE
    print("insert finish:", cost, "per:", per_cost)
end

function test_find_and_remove()
	local db = _create_client()
	db[db_name].testdb:ensureIndex({test_key = 1}, {test_key2 = -1}, {unique = true, name = "test_index"})
    local begin = os.clock()
    local query = {test_key = 0}
    for i=1, SIZE do
        query.test_key = i
        local ret = db[db_name].testdb:findOne(query)
    end
    local finish = os.clock()
    local cost = finish - begin
    local per_cost = cost / SIZE
    print("find finish:", cost, "per:", per_cost)
end

skynet.start(function()
	print("Test insert")
	test_insert()
	print("Test find and remove")
	test_find_and_remove()
	print("mongodb test finish.");
end)
