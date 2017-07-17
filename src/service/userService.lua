local UserService = class('UserService')

function UserService:ctor(userInfo)
    self.userInfo = userInfo
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