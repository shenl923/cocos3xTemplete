--TEST HTTP
--[[
local http = require('src/utils/http')
local method = 'POST'
local url = '127.0.0.1:3000/users/login'
local data =  json.encode({a=1,p=2})

http.request(method, url, data, function(xhr)
	dump(json.decode(xhr.response), 'success')
end, function(xhr)
	dump(xhr.response, 'fail')
end, header)
]]

--TEST SKYNET
--local skynetService = require('src/service/skynetService')
--skynetService:connect()
--skynetService:send('Login', json.encode({account='sl',password='123', roomId=1}))