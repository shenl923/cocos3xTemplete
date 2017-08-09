local UserService = class('UserService')
local eventMediator = require 'src/utils/eventMediator'

function UserService:ctor()
    self.userInfo = nil
end


function UserService:initInfo(value)
    if self.userInfo == nil then 
        self.userInfo = {}
        self.userInfo.id = value.client
        self.userInfo.index = value.index
    end
end

function UserService:getUserInfo()
    return self.userInfo
end

function UserService:getUserId()
    local info = self:getUserInfo()
    if info == nil then
        return nil
    end
    return info.id
end

local userService = UserService.new()
return userService