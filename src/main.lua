-- CC_USE_DEPRECATED_API = true
require "cocos.init"
--local skynet = require "hello2"
local useService = require "service.userService"
-- cclog
cclog = function(...)
    print(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
end

local function initGLView()
    local director = cc.Director:getInstance()
    local glView = director:getOpenGLView()
    if nil == glView then
        glView = cc.GLViewImpl:create("Lua Empty Test")
        director:setOpenGLView(glView)
    end
    director:setOpenGLView(glView)
    glView:setDesignResolutionSize(960, 640, cc.ResolutionPolicy.NO_BORDER)
    --turn on display FPS
    director:setDisplayStats(true)

    --set FPS. the default value is 1.0/60 if you don't call this
    director:setAnimationInterval(1.0 / 60)
end

local function main()
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    
    initGLView()  
    
    local sceneGame = cc.Scene:create()
    cc.Director:getInstance():runWithScene(sceneGame)
    
    dump("Hello");
    
    local bg = cc.Sprite:create("farm.jpg")
    bg:setPosition(200, 200)
    sceneGame:addChild(bg)
end
xpcall(main, __G__TRACKBACK__)

