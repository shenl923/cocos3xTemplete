local function getUniqueId(obj)
    return tonumber(tostring(obj):match(':%s*[0xX]*(%x+)'), 16)
end

local EventObj = class('EventObj')

function EventObj:ctor(name, callback, priority)
    self.name = name
    self.callback = callback
    self.priority = priority
    self.id = getUniqueId(self)
    self:bindHost(self)
end

function EventObj:isHostExist()
    return instanceExist(self._host)
end

function EventObj:bindHost(host)
    self._host = host
    return self
end

EventMediator = class("EventMediator")

function EventMediator:ctor()
    self._priorityCache = {}
    self._events = {}
end

function EventMediator:listen(name, callback, priority)
    if type(name) == 'string' and string.len(name) > 0 then
        callback = type(callback) == 'function' and callback
        priority = priority or self:_pushPriority(name)
        local event = EventObj.new(name, callback, priority)
        self._events[event.id] = event
        return event
    end
end

function EventMediator:publish(name, ...)
    --TODO:callbacks分类可提升遍历效率
    local events = self:_filterEvents(name)
    events = self:_sortEvents(events)
    for _, event in pairs(events) do
        if event:isHostExist() then
            doCallback(event.callback, ...)
        end
    end
end

function EventMediator:removeListener(listener)
    if not listener or not listener.id then return end
    self._events[listener.id] = nil
end

function EventMediator:_pushPriority(name)
    local p = self._priorityCache[name] or 0
    self._priorityCache[name] = p + 1
    return self._priorityCache[name]
end

function EventMediator:_filterEvents(name)
    local events = {}
    --    local count = 0
    for _, event in pairs(self._events) do
        if event.name == name then
            table.insert(events, event)
        end
        if not event:isHostExist() then
            self._events[event.id] = nil
        end
        --        if instanceExist(event) then count = count + 1 end
    end
    --    print('------events num:', count)
    return events
end

function EventMediator:_sortEvents(events)
    table.sort(events, function(a, b)
        return a.priority < b.priority
    end)
    return events
end

local eventMediator = EventMediator.new()
return eventMediator