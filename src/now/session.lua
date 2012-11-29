local base = require("now.base")
local md5 = ngx.md5
local encodebase64 = ngx.encodebase64
local decodebase64 = ngx.decodebase64

---simple session
module(...)

local _mt = { __index = _M }

---传入'_key' 作为密钥
function new(self, o)
	if not o or o['_key'] == nil then
		base.err('can not new session instance without _key')
	end
	o._data = {}
	o.change = false
    return setmetatable(o, _mt)
end

---得到session数据，格式为rand|key|base64(json_data)
--key = md5(rand..data..key)
function init(self, str)
	local arr = base.split('|', str)
	if #arr ~= 3 then
		base.err('init session error')
	end
	local key = md5(arr[1]..self_key..arr[3])
	if key ~= arr[2] then
		base.err('session key error')
	end
	self._data = decodebase64(base.json_decode(arr[3]))
end

---得到新的session字符串
function save(self)
	local rand = tostring(ngx.now * 1000)
	local data = encodebase64(base.json_encode(self._data))
	local key = md5(rand..'|'..self_key..'|'..data)
	local str = rand..'|'..key..'|'..data
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

local _class_mt = {
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable [' .. key .. ']')
    end
}
setmetatable(_M, _class_mt)