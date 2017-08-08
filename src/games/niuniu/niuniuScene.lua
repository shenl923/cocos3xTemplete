require "component.scene.BaseScene"
require "component.BaseCard"

NiuniuScene = class("NiuniuScene", BaseScene)

NiuniuScene.VAR_NEWROUND = 'NIU.NEWROUND'

function NiuniuScene:ctor()
    NiuniuScene.super.ctor(self)
    self:setBackgound("res/niuniubg.png")
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
    local image = BaseCard.new(BaseCard.Color.CLUBS, 8)
    image:move(200, 200)
    image:addTo(self)

    image:setClick(function()
       self:send(NiuniuScene.VAR_NEWROUND, {color = math.random(1,4), value= math.random(1,13)})
    end)
end

function NiuniuScene:onRoomVar(key, value)
    if key == NiuniuScene.VAR_NEWROUND then 
        local image = BaseCard.new(value.color, value.value)
        image:move(-500, -200)
        image:addTo(self)
        image:runAction(cc.MoveTo:create(0.5, cc.p(500,500)))
    end
end
