local _cjson = require("cjson")
local _len = string.len
local _sub = string.sub
local _insert = table.insert
local _ngx = ngx

---now frmamework base module
module(...)

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

---simple string split funciton. will replace by _ngx.re.split later
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

---throw err and write log
--@param    msg     string      错误信息
--@param    code    int         错误代码
--@return   void
function err(msg,code)
    if code == nil then code = 1 end
	if msg == nil then msg = 'err' end
    _ngx.print(json_encode({_m=msg, _c=code, _time=_ngx.time()}))
	local tpl = "%s|%s"
	_ngx.log(_ngx.ERR, string.format(tpl,tostring(code), tostring(msg)))
	error("")
end