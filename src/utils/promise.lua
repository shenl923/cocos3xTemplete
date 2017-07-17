Promise = class('Promise', _promise)

local function null_or_unpack(val)
    if val then
        return unpack(val)
    else
        return nil
    end
end

function Promise:ctor()
    self._state = 'pending'
    self._callbacks = {}
end

function Promise:state()
    return self._state
end

-- server functions
function Promise:reject(...)
    local arg = { ... }
    if not self:state() == 'pending' then 
        print('Promise Error state', self:state(), ...)
        return 
    end 
    self._value = arg
    self._state = 'rejected'
    for i, v in ipairs(self._callbacks) do
        if v.event == 'always' or v.event == 'fail' then
            v.callback(null_or_unpack(arg))
        end
    end
    self._callbacks = {}
end

function Promise:resolve(...)
    local arg = { ... }
    if not self:state() == 'pending' then 
        print('Promise Error state', self:state(), ...)
        return 
    end 
    self._value = arg
    self._state = 'resolved'
    for i, v in ipairs(self._callbacks) do
        if v.event == 'always' or v.event == 'success' then
            v.callback(null_or_unpack(arg))
        end
    end
    self._callbacks = {}
end

function Promise:notify(...)
    local arg = { ... }
    assert(self:state() == 'pending')
    for i, v in ipairs(self._callbacks) do
        if v.event == 'progress' then
            v.callback(null_or_unpack(arg))
        end
    end
end

function Promise:setTimeout(time, msg)
    delayCall(function()
        if instanceExist(self) and self._state == 'pending' then
            self:reject(msg)
        end
    end, time)
end

--public:
-- call by server reject or resolve
function Promise:always(callback)
    if self:state() ~= 'pending' then
        callback(null_or_unpack(self._value))
    else
        table.insert(self._callbacks, { event = 'always', callback = callback })
    end
    return self
end

-- call by server  resolve
function Promise:success(callback)
    if self:state() == 'resolved' then
        callback(null_or_unpack(self._value))
    elseif self:state() == 'pending' then
        table.insert(self._callbacks, { event = 'success', callback = callback })
    end
    return self
end

-- call by server reject
function Promise:fail(callback)
    if self:state() == 'rejected' then
        callback(null_or_unpack(self._value))
    elseif self:state() == 'pending' then
        table.insert(self._callbacks, { event = 'fail', callback = callback })
    end
    return self
end

-- call by server notify (before recvice message)
function Promise:progress(callback)
    if self:state() == 'pending' then
        table.insert(self._callbacks, { event = 'progress', callback = callback })
    end
    return self
end
