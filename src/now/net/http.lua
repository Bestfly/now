local tcp = ngx.socket.tcp
local gsub = string.gsub
local find = string.find
local pairs = pairs

---simple http client。get/post/head/delete/put support
module(...)

local _cfg = {
	timeout = 1000,		--连接超时，默认1秒
	port = 80,			--默认端口为80
	bodyMaxSize = 1024*1024*20,  --20MB  最大的body数
	bodyFetchSize = 1024*8       --8KB   每次取多大
}

-----------------------------------------------------------------------------
-- LuaSocket toolkit.
-- Author: Diego Nehab
-- 
-- Parses a url and returns a table with all its parts according to RFC 2396
-- The following grammar describes the names given to the URL parts
-- <url> := <scheme>://<authority>/<path>;<params>?<query>#<fragment>
-- <authority> := <userinfo>@<host>:<port>
-- <userinfo> := <user>[:<password>]
-- <path> : = {<segment>/}<segment>
-- Input
--   url: uniform resource locator of request
--   default: table with default values for each field
-- Returns
--   table with the following fields, where RFC naming conventions have
--   been preserved:
--     scheme, authority, userinfo, user, password, host, port,
--     path, params, query, fragment
-- Obs:
--   the leading '/' in {/<path>} is considered part of <path>
-----------------------------------------------------------------------------
local function _getUri(url)
    local parsed = {}
    -- empty url is parsed to nil
    if not url or url == '' then 
    	return nil, 'invalid url' 
    end
    
    -- remove whitespace
    -- url = gsub(url, "%s", "")
    -- get fragment
    url = gsub(url, "#(.*)$", function(f)
        parsed.fragment = f
        return ''
    end)
    
    -- get scheme
    url = gsub(url, "^([%w][%w%+%-%.]*)%:", function(s) 
    	parsed.scheme = s
    	return ''
    end)
        
    -- get authority
    url = gsub(url, "^//([^/]*)", function(n)
        parsed.authority = n
        return ''
    end)
    
    -- get query stringing
    url = gsub(url, "%?(.*)", function(q)
        parsed.query = q
        return ''
    end)
    
    -- get params
    url = gsub(url, "%;(.*)", function(p)
        parsed.params = p
        return ''
    end)
    
    -- path is whatever was left
    if url ~= '' then 
    	parsed.path = url 
    else
    	parsed.path = '/'
    end
    
    local authority = parsed.authority
    
    if not authority then 
    	return parsed 
    end
    
    authority = gsub(authority,"^([^@]*)@", function(u) 
	    parsed.userinfo = u
	    return '' 
    end)
    
    authority = gsub(authority, ":([^:]*)$", function(p) 
    	parsed.port = p
		return ''
	end)
	
    if authority ~= '' then 
    	parsed.host = authority 
    end
    if parsed.port == nil then
    	parsed.port = 80
    end
    
    local userinfo = parsed.userinfo
    if not userinfo then 
    	return parsed
    end
    
    userinfo = gsub(userinfo, ":([^:]*)$", function(p) 
    	parsed.password = p
    	return ''
    end)
    
    parsed.user = userinfo
    return parsed
end

---设置头信息
--@param #table uri 访问地址的解析结果table
--@param #table head 用户发过来的自定义头
--@return #table 经过处理的头信息
local function _getHead(uri, head)
	local ret = {
	   ['user-agent'] = 'resty.http/1.0',
       ['connection'] = 'close TE',
       ['te'] = 'trailers',
       ['host'] = uri['host']
	}
	for k,v in pairs(head) do
		ret[string.lower(k)] = v
	end
	return ret
end

---生成发送到服务器端的字符串
--@param #string method	请求的方法
--@param #table uri 请求地址的解析结果table
--@param #table head 头信息
--@return #string 发送给服务器的字符串内容
local function _buildStr(method, uri, head)
	local ret = method..' '..uri['path']
	if uri['query'] ~= nil then
		ret = ret..'?'..uri['query']
	end
	ret = ret..' HTTP/1.1'
	for k,v in pairs(head) do
		ret = ret .. "\r\n" .. k .. ': ' .. v
	end
	return ret
end

---读取返回的body数据
--@param #class sock socket连接实例
--@param #int size 需要读取的数据大小
--@return #string 返回的body内容
local function _fetchBodyData(sock, size)
	local body = ''
	local pSize = _cfg['bodyFetchSize']	--每次接收多大的数据量
	while size and size > 0 do
		if size < pSize then
			pSize = size
		end
		local data, err, partial = sock:receive(pSize)
		if not err then
			if data then
				body = body .. data
			end
		elseif err == 'closed' then
			if partial then
				body = body .. partial
			end
			return body
		else
			return nil, err
		end
		size = size - pSize
	end
	return body
end

---读取返回的header信息
--@param #class sock socket连接实例
--@return #table header内容，已经是k/v的格式了
local function _readHttpHead(sock)
	local ret = {}
	local line, err, partial, name, value
	
    line, err, partial = sock:receive()
	if err then
		return nil,err
	end
	
    while line ~= '' do
    	_, _, name, value = find(line, "^(.-):%s*(.*)")
    	if not (name and value) then
			return nil, 'unknown response header name and value'
    	end
    	name = string.lower(name)
    	
    	line, err, partial = sock:receive()
		if err then
			return nil,err
		end
    	while find(line, "^%s") do
    		value = value .. line
    	    line, err, partial = sock:receive()
			if err then
				return nil,err
			end
    	end
    	if ret[name] then
    		ret[name] = ret[name] .. ',' .. value
    	else
    		ret[name] = value
    	end
    end
    return ret
end

---发送http请求，并取得返回结果
--@param #string method http请求的方法
--@param #string host 请求地址
--@param #int port 端口号
--@param #string str 发送的http请求内容
--@return #code,header,body,err 返回结果
local function _fetchResult(method, host, port, str)
	local ret = {code=200, header={}, body=''}
	
	local sock = tcp()
	if not sock then
		return nil,nil,nil, 'error to init tcp'
	end
	
	--连接到服务器
	sock:settimeout(_cfg['timeout'])
	local ok, err = sock:connect(host, port)
	if err then
		return nil,nil,nil, 'error to connect to host '..host..' in port='..port..' err='..err
	end
	
	--发送请求
	local bytes, err = sock:send(str)
	if err then
		sock:close()
		return nil,nil,nil,'error while send data to '..host..' in port='..port..' err='..err
	end
	
	--读取返回的状态信息
	local status_reader = sock:receiveuntil("\r\n")
	local data, err, partial = status_reader()
    if not data then
    	sock:close()
		return nil,nil,nil, 'failed to read the data stream: '..err
    end
    local _, _, code = find(data, "HTTP/%d*%.%d* (%d%d%d)")
    
    --得到返回状态吗
    code = tonumber(code)
    if not code then
    	sock:close()
		return nil, nil, nil, 'read status error'
    end
    ret['code'] = code
    
    --读取所有的头信息
    local header, err = _readHttpHead(sock)
    if err then
    	sock:close()
		return nil, nil, nil, 'error in read header:'..err
    end
    ret['header'] = header
    
    --根据需要读取body信息  302未处理。
	if ret['code'] == 204 or ret['code'] == 304 then
    	ret['body'] = nil
	elseif ret['code'] >=100 and ret['code'] < 200 then
    	ret['body'] = nil
	else
    	local t = header['transfer-encoding']
    	local body, err
    	if t and t ~= 'identity' then
	    	while true do
	            local chunk_header = sock:receiveuntil("\r\n")
	            local data, err, partial = chunk_header()
	            if not err then
	                if data == '0' then
	                    break
	                else
	                    local size = tonumber(data, 16)
						if size > _cfg['bodyMaxSize'] then
							return nil, nil, nil, 'chunk size > bodyMaxSize'
						end
	                    local tmp, err = _fetchBodyData(sock, size)
	                    if err then
					    	sock:close()
							return nil,nil,nil, 'error in get chunk data'..err
	                    end
	                    body = body .. tmp
	                end
	            end
	        end
		elseif header['content-length'] ~= nil and header['content-length'] ~= '0' then
			local size = tonumber(header['content-length'])
			if size > _cfg['bodyMaxSize'] then
				return nil, nil, nil, 'content-length > bodyMaxSize'
			end
			body, err = _fetchBodyData(sock, size)
		else
			body, err = _fetchBodyData(sock, _cfg['bodyMaxSize'])
		end
		
	    if err then
	    	sock:close()
			return nil, nil, nil, 'error in read header:'..err
	    end
	    ret['body'] = body
    end
	sock:close()
    
    return ret['code'], ret['header'], ret['body']
end

---发送请求
function request(method, url, header, body)
	header = header or {}
	local uri = _getUri(url)
	local header = _getHead(uri, header)
	local str
	if method == 'POST' or method == 'PUT' then
		header['content-length'] = #body
		if header['content-type'] == nil then
			header['content-type'] = 'application/x-www-form-urlencoded'
		end
	    str = _buildStr(method, uri, header)
	    str = str.."\r\n\r\n"..body
	else
		str = _buildStr(method, uri, header)
		str = str.."\r\n\r\n"
	end
	return _fetchResult(method, uri['host'], uri['port'], str)
end

---发送GET请求
function get(url, header)
	return request('GET', url, header)
end

---发送head请求
function head(url, header)
	return request('HEAD', url, header)
end

---发送post请求
function post(url, body, header)
	return request('POST', url, header, body)
end

---发送delete请求
function delete(url, header)
	return request('DELETE', url, header)
end

---发送put请求
function put(url, body, header)
	return request('PUT', url, header, body)
end