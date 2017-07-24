
local socket = require 'socket'
local globalTick = require 'src.utils.globalTick'

SkynetService = class("SkynetService")



local function packShort(a)
    local a1 = bit.band(0xff, a)
    local a2 = bit.rshift(bit.band(0xff00, a), 8)
    return string.char(a2) .. string.char(a1)
end

local function unpackShort(a)
    assert(#a == 2, #a)
    local a2 = a:sub(1, 1)
    local a1 = a:sub(2, 2)
    return bit.lshift(string.byte(a2), 8) + string.byte(a1)
end

local function unpackInt(a)
    assert(#a == 4, #a)
    local a4 = a:sub(1, 1)
    local a3 = a:sub(2, 2)
    local a2 = a:sub(3, 3)
    local a1 = a:sub(4, 4)
    return bit.lshift(string.byte(a4), 24)
            + bit.lshift(string.byte(a3), 16)
            + bit.lshift(string.byte(a2), 8)
            + string.byte(a1)
end

local function packInt(a)
    local a1 = bit.band(0xff, a)
    local a2 = bit.rshift(bit.band(0xff00, a), 8)
    local a3 = bit.rshift(bit.band(0xff0000, a), 16)
    local a4 = bit.rshift(bit.band(0xff000000, a), 24)
    return string.char(a4)
            .. string.char(a3)
            .. string.char(a2)
            .. string.char(a1)
end

function SkynetService:ctor()
    self.tickerId = globalTick:register(handler(self, SkynetService.tick))
end 

function SkynetService:dtor()
    self:close()
    globalTick:remove(self.tickerId)
end

function SkynetService:connect(ip, port)
    local tcp = socket.tcp()
    tcp:settimeout(0)
    local ip = ip or "127.0.0.1"
    local port = port or 8889

    local fd , _ext = tcp:connect(ip, port)

    if not fd and _ext ~= "timeout" then
        prinr(_ext)
    else
        self.conn = tcp
    end
end

function SkynetService:close()
    if self.conn ~= nil then
        self.conn:close()
        self.conn = nil
    end
end

function SkynetService:tick()
    if self.conn == nil then return end 
    local ret = self:_recv(2)
    if ret == nil then
        return
    end
    local size = unpackShort(ret)
    local msg = self:_recv(size)
    local keySize = unpackInt(msg:sub(1, 4))
    local key = msg:sub(5, keySize+4)
    local isCompress = string.byte(msg:sub(keySize + 5, keySize + 5))
    local msgSize = unpackInt(msg:sub(keySize + 6, keySize + 9))
    local value = msg:sub(keySize + 10, msgSize + keySize + 10)
    dump(value, key)
end


function SkynetService:_recv(size)
    local ret, error = self.conn:receive(size)
    if not ret then
        if error ~= 'timeout' then
            print(error)
        end
    else
        return ret
    end
end 


function SkynetService:pack(key, value)
    local sn = packInt(#key)
    local buf = sn 
            .. key
            .. string.char(0)
            .. packInt(#value)
            .. value
    local size = #buf
    return(packShort(size) .. buf)
end 

function SkynetService:send(key, value)
    if self.conn == nil then return end 
    local ret, error = self.conn:send(self:pack(key, value))
    if not ret then
        print(error)
    end
end 

local skynetService = SkynetService.new()
return skynetService