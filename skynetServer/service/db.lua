local skynet = require "skynet"
local mysql = require "mysql"

local CMD = {}
local param = ...
if param == nil then
    param = {}
    param[1] = {
        host="127.0.0.1",
        port=3306,
        database="game",
        user="root",
        password="1234",
        max_packet_size = 1024 * 1024
    }
end

local config = param[1]

local db
function CMD.execute(...)
    return db:query(...)
end

function CMD.exit()
    db:disconnect()
    skynet.exit()
end

skynet.start(function()
    db = mysql.connect(config)
    if not db then
        print("failed to connect")
        print("db config ========")
        for k,v in pairs(config) do
            print(k,v)
        end
        print("==================")
        skynet.exit()
    end

    skynet.dispatch("lua", function(_,_, command, ...)
        local f = CMD[command]
        skynet.ret(skynet.pack(f(...)))
    end)
end)

