local skynet = require "skynet"
local size
local player = {}

local CMD = {}

function CMD.enter(agent, client_fd)
    print('agent, client_fd', agent, client_fd)
   
    for k, _agent in pairs (player) do 
        if _agent == agent then 
            table.remove(player, k)
            break
        end
    end 
    table.insert(player, agent)

	for k, agent in pairs(player) do
		skynet.call(agent, "lua","send","login", {client=client_fd})
	end	
end

function CMD.exit(agent)
    for k, _agent in pairs (player) do 
        if _agent == agent then 
            table.remove(player, k)
            break
        end
    end 
end

skynet.start(function()
	skynet.dispatch("lua", function(_,_, command, ...)
		local f = CMD[command]
		skynet.ret(skynet.pack(f(...)))
	end)
	size = 0
end)
