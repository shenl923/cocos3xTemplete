require 'utils.promise'

local globalTick = require 'src/utils/globalTick'

ApiService = class('ApiService')

local http = require('src/utils/http')
local localStorage = require('src/utils/localStorage')
local eventMediator = require 'src/utils/eventMediator'

if DEV_MODE then
    ApiService.API_URL_BASE = "https://127.0.0.1:3000/"
else
    ApiService.API_URL_BASE = "https://127.0.0.1:3000/"
end

ApiService.EVENT_TOKEN_FAIL = 'ApiService.tokenFail'

function ApiService:ctor()
    self.tokenInfo = {
        access_token = '',
        expires = -1
    }
end

function ApiService:request(apiDef, data)
    local promise = Promise.new()

    if apiDef:isRequireToken() and not self:hasValidToken() then
        promise:reject('ApiService.request: hasValidToken')
        eventMediator:publish(ApiService.EVENT_TOKEN_FAIL, apiDef)
        return promise
    end

    local url = ApiService.API_URL_BASE .. apiDef:getUrl()
    if apiDef:getUrl() == 'app/versions' then
        url = 'http://api.97kid.com/' .. apiDef:getUrl()
    end
    local method = apiDef:getMethod()

    if method == 'POST' and type(data) == "table" then
        data = json.encode(data)
    end

    if method == 'GET' and data ~= nil and data ~= '' then
        url = url .. '?' .. tostring(data)
    end

    local header = {}
    header['Content-Type'] = 'application/json'
    if apiDef:isRequireToken() then
        header['Authorization'] = 'Bearer ' .. self.tokenInfo.access_token
    end

    http.request(method, url, data, function(xhr)
        promise:resolve(json.decode(xhr.response), xhr)
    end, function(xhr)
        promise:reject(xhr.response)
    end, header)

    promise:setTimeout(15, apiDef:getName() .. ' timeout')

    return promise
end

function ApiService:setToken(token, expires)
    self.tokenInfo = {
        access_token = token,
        expires = expires
    }
end

function ApiService:getExpires()
    if self.tokenInfo == nil then
        return nil
    end
    return self.tokenInfo.expires
end

function ApiService:getToken()
    if self:hasValidToken() then
        return self.tokenInfo and self.tokenInfo.access_token
    end
    return nil
end

function ApiService:hasValidToken()
    if self.tokenInfo == nil then
        self.tokenInfo = localStorage.tokenInfo
    end
    return self.tokenInfo ~= nil and self.tokenInfo.expires > os.time()
end

function ApiService:clearToken()
    self.tokenInfo = nil
    localStorage.tokenInfo = nil
end

function ApiService:fetch(apiDef, param)
    local data = clone(param)
    local response = {}
    local startTime = os.clock() * 1000
    local promise = self:request(apiDef, data)

    promise:always(function(data)
        local duration = os.clock() * 1000 - startTime
        trackerService:trackTiming('ApiRequest', 'S.' .. apiDef:getUrl(), duration)
        response.data = data
    end):success(function(data)
        response.success = true
        eventMediator:publish(apiDef:getName(), response)
    end):fail(function(data)
        print('[API FAIL]:', apiDef:getErrorTips(), 'retry..' .. apiDef:getRetryTimes())
        if apiDef:getRetryTimes() > 0 then
            self:fetch(apiDef, param)
            apiDef:reduceRetryTimes()
        else
            eventMediator:publish(apiDef:getName(), response)
            if DEV_MODE then
                ccs.showToast('url: ' .. apiDef:getUrl() .. g_language[100])
            else
                ccs.showToast(g_language[100])
            end
        end
    end)
end

local apiServer = ApiService.new()
return apiServer