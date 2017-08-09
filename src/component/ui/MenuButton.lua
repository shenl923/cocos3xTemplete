
MenuButton = class("MenuButton", function()
    return ui.createNode('res/ui/teacherButton.csb')
end)

local eventMediator = require 'src/utils/eventMediator'

MenuButton.SKIN_WHITE = 0
MenuButton.SKIN_CAMEL = 1
MenuButton.SKIN_RED = 2
MenuButton.SKIN_GREEN = 3
MenuButton.SKIN_BLUE = 4
MenuButton.SKIN_YELLOW = 5
MenuButton.SKIN_PURPLE = 6

function MenuButton:ctor(label, pressType)
    self:setLabel(label)
    --scale or color
    self.pressType = pressType or 'scale'
end

function MenuButton:setFontName(name)
    self.label:setFontName(name)
end

function MenuButton:setColor(color)
    self.bottom:setColor(color)
    return self
end

function MenuButton:setFontColor(color)
    self.label:setTextColor(color)
    return self
end

function MenuButton:setLabel(label)
    label = tostring(label)
    self.label:setString(label or '')
    ui.adjustLabelBottomWidth(self.label, self.content, 60)
    ccui.Helper:doLayout(self.content)
    return self
end

function MenuButton:setSkin(type)
    self:setFontColor(hexColor(0xffffff))
    if type == MenuButton.SKIN_CAMEL then
        self:setColor(hexColor(0xb7ad86))
    elseif type == MenuButton.SKIN_RED then
        self:setColor(hexColor(0xf06279))
    elseif type == MenuButton.SKIN_GREEN then
        self:setColor(hexColor(0x26a69a))
    elseif type == MenuButton.SKIN_BLUE then
        self:setColor(hexColor(0x26b6da))
    elseif type == MenuButton.SKIN_YELLOW then
        self:setColor(hexColor(0xffa726))
    elseif type == MenuButton.SKIN_PURPLE then
        self:setColor(hexColor(0xba68c8))
    elseif type == MenuButton.SKIN_WHITE then
        self:setFontColor(hexColor(0x303030))
        self:setColor(hexColor(0xffffff))
    end
    return self
end

function MenuButton:getSize()
    return self.content:getContentSize()
end

function MenuButton:setSize(width, height)
    self.content:setContentSize(width, height)
    ccui.Helper:doLayout(self.content)
    return self
end

function MenuButton:setFontSize(value)
    self.label:setFontSize(value)
    return self
end

--[[
function MenuButton:setMouseOverTips(label)
    if not self.tipBox then
        self.tipBox = TipBox.new(label):addTo(self):move(0, -62):hide()
        ccs.onMouseOver(self.ui.content, function(isIn)
            self.tipBox:setVisible(isIn)
            if isIn then
                self.tipBox:limitBounding()
            end
        end)
    end
    self.tipBox:setLabel(label)
    return self
end
]]

function MenuButton:click(callback)
    ui.setButton(self.content, function(sender)
        doCallback(callback, self)
    end, self.pressType)
    return self
end

function MenuButton:setActive(value)
    if value == true then
        self:setOpacity(255)
        self.content:setTouchEnabled(true)
    else
        self:setOpacity(60)
        self.content:setTouchEnabled(false)
    end
    return self
end