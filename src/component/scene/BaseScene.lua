local eventMediator = require 'src/utils/eventMediator'
local skynetService = require 'src.service.skynetService'

BaseScene = class("BaseScene",function()
    return display.newScene()
end)

function BaseScene:ctor()
    self:enableNodeEvents()
end

function BaseScene:onEnter()
    local ip = "119.29.236.179"
    --local ip = "127.0.0.179"
    local port = "8888"
    skynetService:connect(ip, port)
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

function BaseScene:setBackgound(res)
    local bg = ccui.ImageView:create(res)
    local size = ui.getWinSize()
    bg:ignoreContentAdaptWithSize(false)
    bg:setContentSize(size.width, size.height)
    bg:move(size.width/2, size.height/2)
    bg:addTo(self,-10)
end

        
        
