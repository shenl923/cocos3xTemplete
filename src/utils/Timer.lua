Timer = class('timer')

function Timer:ctor(timeOut)
    self._timeout = timeOut
    self.targetTime = os.time() + self._timeout
end

function Timer:isTimeOut()
    return os.time() > self.targetTime
end

function Timer:reset()
    self.targetTime = os.time() + self._timeout
end
