local eventMediator = require 'src/utils/eventMediator'
local skynetService = require 'src.service.skynetService'

BaseScene = class("BaseScene",function()
    return display.newScene()
end)

function BaseScene:ctor()
    self:enableNodeEvents()
end

function BaseScene:onEnter()
    skynetService:connect()
    skynetService:enterRoom(1)

    eventMediator:listen(SkynetService.EVENT_SKYNET_RECVICE, function(key, value)
        self:onRoomVar(key, value)
    end)

end

function BaseScene:onExit()

end

function BaseScene:send(key, value)
    local tb = {}
    tb = {k = key, v = value}
    skynetService:send(SkynetService.ServiceUpdateVar, json.encode(tb))
end

function BaseScene:onRoomVar(key, value)
  
end
        
        
