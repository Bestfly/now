---use redis for dao cache. need resty.redis installed
module("now.cache.redis",package.seeall)

local _cls = now.cache.redis
local _mt = { __index = _cls}
local _redis = require("resty.redis")
local _tbl = require("now.util.tbl")

--- host port
function new(self, o)
	o = o or {}
	_tbl.add_to_tbl(o, {
		keepalive=200,
		timeout=1000,
		pool = 100
	})
    return setmetatable(o, _mt)
end

---open socket
function open(self)
	self.redis_cls = _redis:new()
	self.redis_cls:set_timeout(self.timeout)
    local ok, err = self.redis_cls:connect(self.host,  self.port)
    if err then
    	return false , "error to connet redis err="..err
    else
    	return true
    end
end

function get(self, key)
	if self.redis_cls ~= nil then
		local res, err = self.redis_cls:get(key)
	    if err then
	    	return nil, "error to get data. err="..err
	    end
	    if not res then
			return nil
		else
			return res
	    end
	else
		return false, "conn is not exist"
	 end
end

function mget(self, keys)
	if self.redis_cls ~= nil then
		local ret = {}
		for _, k in ipairs(keys) do
			ret[k] = self.redis_cls:get(k)
		end
		return ret
	else
		return false, "conn is not exist"
	 end
end

function set(self, key, val, expired)
    expired = expired or 0
	return self.redis_cls:setex(key, expired, val)
end

function mset(self, tbl, expired)
    expired = expired or 0
	if self.redis_cls ~= nil then
		for k, v in pairs(tbl) do
			self.redis_cls:setex(k, expired, v)
		end
		return true
	else
		return false, "conn is not exist"
	end
end

function del(self, key)
	if self.redis_cls ~= nil then
		return self.redis_cls:del(key)
	else
		return false, "conn is not exist"
	end
end

function mdel(self, tbl)
	if self.redis_cls ~= nil then
		for _, v in ipairs(tbl) do
			self.redis_cls:del(key)
		end
		return true
	else
		return false, "conn is not exist"
	end
end

function incr(self, key, num)
	num = num or 1
	if self.redis_cls ~= nil then
		return self.redis_cls:incrby(key, num)
	else
		return false, "conn is not exist"
	end
end

function close(self)
	self.redis_cls:set_keepalive(self.keepalive,  self.pool)
end

getmetatable(_cls).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end