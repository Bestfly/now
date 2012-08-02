---now frmamework base module
module("now.base", package.seeall)

local _init = false
local _cjson = require("cjson")
local _len = string.len
local _sub = string.sub
local _insert = table.insert
--cjson.encode_sparse_array(true)

---encode table to json string
--@param #table tbl table will be encode
function json_encode(tbl)
	return _cjson.encode(tbl)
end

---get table from json string
--@param #string str json string
function json_decode(str)
	return _cjson.decode(str)
end

---simple string split funciton. will replace by ngx.re.split later
--@param #string str string will be split
--@param #string delimiter
function split(str, delimiter)	
	local s = ""
	local mi = _len(str) + 1
	local tmp = ""
	local i = 1
	local result = {}
	while i < mi do
		tmp = _sub(str,i,i)
		if tmp == delimiter  then
			_insert(result,s)
			s = ""
			i = i + 1
		else
			s = s .. tmp
			i = i + 1
		end
	end
	_insert(result,s)
	return result
end

---抛出异常
--@param    msg     string      错误信息
--@param    code    int         错误代码
--@return   void
function err(msg,code)
    if code == nil then code = 1 end
	if msg == nil then msg = 'err' end
    ngx.print(json_encode({_m=msg,_c=code,_time=ngx.time()}))
	local tpl = "%s|%s|%s"
	ngx.log(ngx.ERR,string.format(tpl,tostring(code),tostring(ngx.ctx.uid),tostring(msg)))
	error('')
end

--使用ngx_lua内置的非阻塞http方式发送一次http请求,并得到返回结果
--@param    url         string  请求的URL
--@param    para   		table  请求的参数
--@param    is_post     boolean 是否是POST方式
function http_send(url, para, is_post)
	ngx.req.set_header("Accept-Encoding", "")

	if is_post then
		local str = ""
		if type(para) ~= "string" then
			str = ngx.encode_args(para)
		else
			str = para
		end
		ngx.req.set_header("Content-Type", "application/x-www-form-urlencoded")
		res = ngx.location.capture(url,{method = ngx.HTTP_POST, body=str})
	else
		res = ngx.location.capture(url,{method = ngx.HTTP_GET})
	end

	if res.status ~= 200 then
		error("error to fetch url="..url.." status="..tostring(res.status))
	end
	return res.body
end