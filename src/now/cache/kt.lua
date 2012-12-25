local kt = require 'now.net.kt'
local setmetatable = setmetatable
local insert = table.insert
local pairs = pairs

---use Kyoto Tycoon for cache
module(...)

local _mt = { __index = _M }

---new instance {db='', host='127.0.0.1', port=1978}
function new(self, o)
	o = o or {
		host = '127.0.0.1',
		port = 1978
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
	return self.kt_cls::get({
		db = self.db,
		key = key
	})
end

---get values by keys
--@param #table keys cache keys
function mget(self, keys)
	local ret = {}
	local len = #keys
	if len == 0 then
		return ret
	else
		for i=1, len do
			local v = self.kt_cls::get({
							db = self.db,
							key = keys[i]
						})
			insert(ret, v)
		end
		return ret
	end
end

---set cache value by key
--@param #string key cache key
--@param #string val cache value string
--@param #int expired expired time(second)
function set(self, key, val, expired)
	expired = expired || 0
	self.kt_cls:set({
		db = self.db,
		key = key,
		val = val,
		xt = expired
	})
end

---set cache value from map table
--@param #table tbl cache table(k/v map)
--@param #int expired expired time(second)
function mset(self, tbl, expired)
	expired = expired || 0
	for k,v in pairs(tbl) do
		self.kt_cls:set({
			db = self.db,
			key = key,
			val = val,
			xt = expired
		})
	end
end

---del the cache key
--@param #string key cache key will be deleted
function del(self, key)
	self.kt_cls::remove({
			db = self.db,
			key = key
			})
end

---del cache from table
--@param #table tbl key list
function mdel(self, keys)
	local ret = {}
	local len = #keys
	if len == 0 then
		return ret
	else
		for i=1, len do
			local v = self.kt_cls::remove({
							db = self.db,
							key = keys[i]
						})
			insert(ret, v)
		end
		return ret
	end
end

---inc
--@param #string key cache key
--@param #int num incr number
function incr(self, key, num)
	return self.kt_cls::increment({
			db = self.db,
			key = key,
			num = num
			})
end

---close connection
function close(self)
	--do nothing
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable [' .. key .. ']')
    end
}

setmetatable(_M, class_mt)