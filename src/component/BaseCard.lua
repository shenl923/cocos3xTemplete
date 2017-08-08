BaseCard = class("BaseCard", function(...)
    return display.newNode()
end)

 BaseCard.Color = {
    DIAMONDS = 1,   --方片
    CLUBS = 2,      --草花
    SPADES = 3,     --黑桃
    HEARTS = 4,     --红桃
 }


function BaseCard:ctor(color, value)
    self:enableNodeEvents()
    self.color = color
    self.value = value
end

function BaseCard:onEnter(...)
    self:initView()
end

function BaseCard:onExit(...)
  
end

function BaseCard:initView()
    local width = 1820/13
    local height = 777/4
    local rect = cc.rect((self.value - 1)*width, (self.color - 1)*height, width, height);
    local view = ccui.ImageView:create('res/pukes.png')
    view:addTo(self)
    view:setTextureRect(rect)
    view:setContentSize(rect)
    view:ignoreContentAdaptWithSize(false)
    self.ui = view
end 

function BaseCard:setClick(fn)
    self.ui:setTouchEnabled(true)
    ui.setButton( self.ui,function()
        if fn then fn() end
    end)
end 