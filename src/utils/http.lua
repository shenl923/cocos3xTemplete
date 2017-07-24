local http = {}

http.REQUEST_TIMEOUT = 10

local function dumpXhr(xhr)
    -- dump(xhr)
end

function http.request(method, url, data, success, fail, header)
    data = data or ''
    local success = success or dumpXhr
    local fail = fail or dumpXhr
    local header = header or {}
    local method = method or 'GET'

    if method == 'PUT' then
        header['X-HTTP-METHOD-OVERRIDE'] = 'PUT'
    end

    local xhr = cc.XMLHttpRequest:new()
    for k,v in pairs(header) do
        xhr:setRequestHeader(k,v)
    end
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    xhr.timeout = http.REQUEST_TIMEOUT

    xhr:open(method, url)
    xhr:registerScriptHandler(function ()
        if xhr.status >= 200 and xhr.status < 300 then
            success(xhr)
        else
            fail(xhr)
        end
    end)
    xhr:send('data='..data)
	print(method .. ' ' .. url)
    return xhr
end

function http.get(url, success, fail, header)
    return http.request('GET', url, '', success, fail, header)
end

function http.post(url, data, success, fail, header)
    return http.request('POST', url, data, success, fail, header)
end

function http.put(url, data, success, fail, header)
    return http.request('PUT', url, data, success, fail, header)
end



return http
