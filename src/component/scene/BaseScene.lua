BaseScene = class("BaseScene",function()
    return display.newScene()
end)

function BaseScene:ctor()
    self:enableNodeEvents()
end

function BaseScene:onEnter()
end

function BaseScene:onExit()

end
