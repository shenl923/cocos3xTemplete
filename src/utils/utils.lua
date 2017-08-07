function getUniqueId(obj)
    return tonumber(tostring(obj):match(':%s*[0xX]*(%x+)'), 16)
end

function doCallback(func, ...)
    if type(func) == 'function' then
        func(...)
        return true
    end
end

function center(size)
    return cc.p(size.width / 2, size.height / 2)
end

function delayCall(callback, delayTime)
    local schedule = cc.Director:getInstance():getScheduler()
    local handle
    handle = schedule:scheduleScriptFunc(function()
        schedule:unscheduleScriptEntry(handle)
        callback()
    end, delayTime, false)
    return handle
end

function loopCall(callback, loopTime)
    local schedule = cc.Director:getInstance():getScheduler()
    local handle
    handle = schedule:scheduleScriptFunc(function()
        local status, msg = xpcall(callback, __G__TRACKBACK__)
        if not status then
            stopLoopCall(handle)
        end
    end, loopTime, false)
    return handle
end

function stopLoopCall(handle)
    if handle == nil then return end
    local schedule = cc.Director:getInstance():getScheduler()
    schedule:unscheduleScriptEntry(handle)
end

function LogToFile(...)
    local path = toGBK(getPacketPath() .. "error.txt")
    local file, error = io.open(path, "a+");
    if file == nil then
        print(error)
        return
    end
    file:write(...)
    file:close()
end

function hexColor(color)
    local r = math.floor(color / 2 ^ 16)
    local g = math.floor(color / 2 ^ 8) - math.floor(r * 2 ^ 8)
    local b = color - math.floor(math.floor(color / 2 ^ 8) * 2 ^ 8)
    return cc.c3b(r, g, b)
end

function instanceExist(target)
    if target and type(target) ~= 'userdata' then return true end
    return not tolua.isnull(target)
end
