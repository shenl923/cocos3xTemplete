require "component.scene.BaseScene"
require "component.BaseCard"
require "component.ui.MenuButton"
require "games.niuniu.Pukes"

NiuniuScene = class("NiuniuScene", BaseScene)
NiuniuScene.USR_VAR_NEWCARD= 'nn.uv_vc'

local useService = require "service.userService"

function NiuniuScene:ctor()
    NiuniuScene.super.ctor(self)
    self:setBackgound("res/niuniubg.png")
    self.pukes = Pukes.new()
    self.cards = {}
end

function NiuniuScene:onEnter(...)
    NiuniuScene.super.onEnter(self)
    --self:checkResUpdate()
    self:createView()
end

function NiuniuScene:onExit()
    NiuniuScene.super.onExit(self)
end

function NiuniuScene:createView()
    local size = ui.getWinSize()
    local button = MenuButton.new('START')
    button:move(120, size.height - 100):addTo(self)
    button:click(function()
         self:sendUserVar(useService:getUserId(),NiuniuScene.USR_VAR_NEWCARD, {color = math.random(1,4), value= math.random(1,13)})
         --self:sendRoomVar(NiuniuScene.USR_VAR_NEWCARD, {color = math.random(1,4), value= math.random(1,13)})
    end)

end

function NiuniuScene:onRoomVar(key, value)
    if key == NiuniuScene.VAR_NEWROUND then 
        local image = cc.Sprite:create('res/blocks.png')  --BaseCard.new(value.color, value.value)
        local size = ui.getWinSize()
        image:move(size.width/2, -500)
        image:runAction(cc.MoveTo:create(0.5, cc.p(size.width/2,size.height/2)))
    end
end

function NiuniuScene:onUserVar(id, key, var)
    if NiuniuScene.USR_VAR_NEWCARD == key then 
        self:handleNewCard(id, var)
    end 
end

function NiuniuScene:handleNewCard(id, value)
    local size = ui.getWinSize()
    local image = BaseCard.new(value.color, value.value)
    image:addTo(self)

    if id == useService:getUserId() then 
        image:move(size.width/2, -500)
        image:runAction(cc.MoveTo:create(0.5, cc.p(size.width/2,size.height/2 - 200)))
    else
        image:move(size.width/2, size.height + 500)
        image:runAction(cc.MoveTo:create(0.5, cc.p(size.width/2,size.height/2 + 200)))       
    end 
end



