local redis = require 'resty.redis'
local tbl = require 'now.util.tbl'
local setmetatable = setmetatable
local pairs = pairs

---use redis for dao cache. need resty.redis installed
module(...)

local _mt = { __index = _M }

--- new instance {host='', port='', keepalive=200, timeout=1000, pool=100}
function new(self, o)
	o = o or {}
	tbl.addToTbl(o, {
		host = '127.0.0.1',
		port = 6379,
		keepalive = 200,
		timeout = 1000,
		pool = 100
	})
    return setmetatable(o, _mt)
end

---open socket
function open(self)
	self.redisCls = redis:new()
	self.redisCls:set_timeout(self.timeout)
    local ok, err = self.redisCls:connect(self.host,  self.port)
    if err then
    	return false , 'error to connet redis err='..err
    else
    	return true
    end
end

---get cache value by key
--@param #string key cache key
function get(self, key)
	if self.redisCls ~= nil then
		local res, err = self.redisCls:get(key)
	    if err then
	    	return nil, 'error to get data. err='..err
	    end
	    if not res then
			return nil
		else
			return res
	    end
	else
		return false, 'conn is not exist'
	 end
end

---get values by keys
--@param #table keys cache keys
function mget(self, keys)
	if self.redisCls ~= nil then
		local ret = {}
		local nkeys = #keys
		
		if nkeys == 0 then
			return ret
		end
		
		for i=1, nkeys do
			ret[k] = self.redisCls:get(keys[i])
		end
		return ret
	else
		return false, 'conn is not exist'
	 end
end

---set cache value by key
--@param #string key cache key
--@param #string val cache value string
--@param #int expired expired time(second)
function set(self, key, val, expired)
    expired = expired or 0
	return self.redisCls:setex(key, expired, val)
end

---set cache value from map table
--@param #table tbl cache table(k/v map)
--@param #int expired expired time(second)
function mset(self, tbl, expired)
    expired = expired or 0
	if self.redisCls ~= nil then
		for k, v in pairs(tbl) do
			self.redisCls:setex(k, expired, v)
		end
		return true
	else
		return false, 'conn is not exist'
	end
end

---del the cache key
--@param #string key cache key will be deleted
function del(self, key)
	if self.redisCls ~= nil then
		return self.redisCls:del(key)
	else
		return false, 'conn is not exist'
	end
end

---del cache from table
--@param #table tbl key list
function mdel(self, keys)
	if self.redisCls ~= nil then
		local nkeys = #keys
		
		for i=1, nkeys do
			self.redisCls:del(keys[i])
		end
		return true
	else
		return false, 'conn is not exist'
	end
end

---inc
--@param #string key cache key
--@param #int num incr number
function incr(self, key, num)
	num = num or 1
	if self.redisCls ~= nil then
		return self.redisCls:incrby(key, num)
	else
		return false, 'conn is not exist'
	end
end

---close connection
function close(self)
	self.redisCls:set_keepalive(self.keepalive,  self.pool)
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable [' .. key .. ']')
    end
}

setmetatable(_M, class_mt)