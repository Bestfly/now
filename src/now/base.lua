local require = require
local len = string.len
local sub = string.sub
local insert = table.insert
local ngx = ngx

---now frmamework base module
module(...)
--cjson.encode_sparse_array(true)
local json

---get json module
local _cjson = function()
	json = require 'cjson'
end
if not json then
	pcall(_cjson)
	if not json then
		json = require 'util.dkjson'
	end
end

---encode table to json string
--@param #table tbl table will be encode
function jsonEncode(tbl)
	return json.encode(tbl)
end

---get table from json string
--@param #string str json string
function jsonDecode(str)
	return json.decode(str)
end

---simple string split funciton. will replace by ngx.re.split later
--@param #string str string will be split
--@param #string delimiter
function split(str, delimiter)	
	local s = ''
	local mi = len(str) + 1
	local tmp = ''
	local i = 1
	local result = {}
	while i < mi do
		tmp = sub(str,i,i)
		if tmp == delimiter  then
			insert(result,s)
			s = ''
			i = i + 1
		else
			s = s .. tmp
			i = i + 1
		end
	end
	insert(result,s)
	return result
end

---throw err and write log
--@param #string  msg error msg
--@param #int code error code
--@return   void
function error(msg, code)
    if code == nil then code = 1 end
	if msg == nil then msg = 'err' end
    ngx.print(json_encode({_m=msg, _c=code, _time=ngx.time()}))
	local tpl = '%s|%s'
	ngx.log(ngx.ERR, string.format(tpl,tostring(code), tostring(msg)))
	error('')
end
