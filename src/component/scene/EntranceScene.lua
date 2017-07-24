require "component.scene.BaseScene"
-- "component.scene.EntranceScene"

EntranceScene = class("EntranceScene", BaseScene)

function EntranceScene:ctor()
    EntranceScene.super.ctor(self)
end

function EntranceScene:onEnter(...)
    EntranceScene.super.onEnter(self)
    local bg = cc.Sprite:create("farm.jpg")
    bg:setPosition(200, 200)
    self:addChild(bg)
end

function EntranceScene:onExit()
    EntranceScene.super.onExit(self)
end
