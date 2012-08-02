---now frmamework base module
module("now.base", package.seeall)

local cjson = require("cjson")
local len = string.len
local sub = string.sub
local insert = table.insert
--cjson.encode_sparse_array(true)

---encode table to json string
--@param #table tbl table will be encode
function json_encode(tbl)
	return cjson.encode(tbl)
end

---get table from json string
--@param #string str json string
function json_decode(str)
	return cjson.decode(str)
end

---simple string split funciton. will replace by ngx.re.split later
function split(str, delimiter)	
	local s = ""
	local mi = len(str) + 1
	local tmp = ""
	local i = 1
	local result = {}
	while i < mi do
		tmp = sub(str,i,i)
		if tmp == delimiter  then
			insert(result,s)
			s = ""
			i = i + 1
		else
			s = s .. tmp
			i = i + 1
		end
	end
	insert(result,s)
	return result
end