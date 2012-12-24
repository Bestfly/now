local kt = require 'now.net.kt'
local setmetatable = setmetatable

---use Kyoto Tycoon  for cache
module(...)

local _mt = { __index = _M }

---初始化，需包含的参数为 {host='',port=''}
function new(self, o)
	o = o or {
		host = '127.0.0.1',
		port = 1978,
		timeout = 1000
	}
	o['kt'] = kt:new({
		host = o.host,
		port = o.port
	})
    return setmetatable(o, _mt)
end

---open socket
function open(self)
	self.kt_cls = redis:new({
		host = self.host,
		port = self.port
	})
	return true
end

---get cache value by key
--@param #string key cache key
function get(self, key)
end

---get values by keys
--@param #table keys cache keys
function mget(self, keys)
end

---set cache value by key
--@param #string key cache key
--@param #string val cache value string
--@param #int expired expired time(second)
function set(self, key, val, expired)
end

---set cache value from map table
--@param #table tbl cache table(k/v map)
--@param #int expired expired time(second)
function mset(self, tbl, expired)
end

---del the cache key
--@param #string key cache key will be deleted
function del(self, key)
end

---del cache from table
--@param #table tbl key list
function mdel(self, keys)
end

---inc
--@param #string key cache key
--@param #int num incr number
function incr(self, key, num)
end

---close connection
function close(self)
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable [' .. key .. ']')
    end
}

setmetatable(_M, class_mt)