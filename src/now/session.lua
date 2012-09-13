---simple session
module("now.session", package.seeall)

local _cls = now.session
local _mt = {__index = _cls}
local _tbl = require("now.util.tbl")
local _base = require("now.base")
local _md5 = ngx.md5
local _encode_base64 = ngx.encode_base64
local _decode_base64 = ngx.decode_base64

---传入'_key' 作为密钥
function new(self, o)
	if not o or o['_key'] == nil then
		_base.err('can not new session instance without _key')
	end
	o._data = {}
	o.change = false
    return setmetatable(o, _mt)
end

---得到session数据，格式为rand|key|base64(json_data)
--key = md5(rand..data..key)
function init_data(self, str)
	local arr = _base.split('|', str)
	if #arr ~= 3 then
		_base.err('init session error')
	end
	local key = _md5(arr[1]..self_key..arr[3])
	if key ~= arr[2] then
		_base.err('session key error')
	end
	self._data = _decode_base64(_base.json_decode(arr[3]))
end

---得到新的session字符串
function get_session_str(self)
	local rand = tostring(ngx.now * 1000)
	local data = _encode_base64(_base.json_encode(self._data))
	local key = _md5(rand..'|'..self_key..'|'..data)
	return rand..'|'..key..'|'..data
end

--- get session data by key
function get(self, key)
	return self._data[key]
end

--- set session data
function set(self, key, val)
	self.change = true
	self._data[key] = val
end

--- delete session key
function del(self, key)
	self.change = true
	self._data[key] = nil
end

--- destroy session
function clear(self)
	self.change = true
	self._data = {}
end

getmetatable(_cls).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end