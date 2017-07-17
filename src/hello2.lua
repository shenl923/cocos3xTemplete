local socket = require 'socket'
local skynet = {}

function skynet:connect()
    local tcp = socket.tcp()
    tcp:settimeout(0)


    local ip = "127.0.0.1"
    local port = 8889

    local fd , _ext = tcp:connect(ip, port)

    if not fd and _ext ~= "timeout" then
        prinr(_ext)
    else
        self.conn = tcp
    end
end

function skynet:tick()
   if self.conn == nil then return end 

   self:recv(5)
end


function skynet:recv(size)
    local ret, error = self.conn:receive(size)

    if not ret then
        if error ~= 'timeout' then
            print(error)
        end
    else
        return ret
    end
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


local function packShort(a)
    local a1 = bit.band(0xff, a)
    local a2 = bit.rshift(bit.band(0xff00, a), 8)
    return string.char(a2) .. string.char(a1)
end

function skynet:pack()
    local name = 'hello'
    local msg = 'skynet'
    local buf = packInt(#name)
            .. name
            .. string.char(0)
            .. packInt(#msg)
            .. msg

    local size = #buf
    return(packShort(size) .. buf)
end 

function skynet:send(pack)
    if self.conn == nil then return end 


    local ret, error = self.conn:send(self:pack())
    if not ret then
        print(error)
    else
        print("send ok", pack)
    end

end 

return skynet