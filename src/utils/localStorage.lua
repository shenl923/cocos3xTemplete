local localStorage = {}
local filename = "userdata"

function localStorage:load()
    local path = filename
    path = cc.FileUtils:getInstance():getWritablePath()..filename;
    path = toGBK(path)
    local file = io.open(path, "r");
    if file ~= nil then
        local s  = file:read("*a")
        if string.len(s) > 0 then
            local ret, msg = xpcall(function ( ... )
                self._data = json.decode(s)
            end, __G__TRACKBACK__)
            if not ret then
                print("error in json.decode")
                self._data = {}
            end
        else
            self._data = {}
        end
        if type(self._data) ~= "table" then
            self._data = {}
        end
        file:close()
    end
end

function localStorage:save()
    local path = filename
    path = cc.FileUtils:getInstance():getWritablePath()..filename;
    path = toGBK(path)
    local file = io.open(path, "w+");
    if file ~= nil then
        file:write(json.encode(self._data))
        file:close()
    end
end

function localStorage:clear()
    self._data = {}
    self:save()

    self._isLoaded = true
end

localStorage._data = {}
localStorage.isloaded = false

local mt = {
    __index = function(t, k)
        if localStorage.isloaded == false then
            localStorage:load();
            localStorage.isloaded = true
        end
        k = tostring(k)
        return localStorage._data[k]
    end,

    __newindex =  function (t, k, v)
        if localStorage.isloaded == false then
            localStorage:load();
            localStorage.isloaded = true
        end
        k = tostring(k)

        localStorage._data[k] = v
        localStorage:save()
    end
}

setmetatable(localStorage, mt)

return localStorage
