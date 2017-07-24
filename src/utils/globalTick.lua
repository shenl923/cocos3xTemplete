globalTick = {}
globalTick.tickers = {}

function globalTick:register(fn)
    local idx = #globalTick.tickers + 1
    self.tickers[idx] = fn
    return idx
end

function globalTick:remove(id)
    self.tickers[id] = nil
end

function globalTick:tick()
    for _, tick in pairs(globalTick.tickers) do
        tick()
    end
end

return globalTick