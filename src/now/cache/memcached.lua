local memcached = require 'resty.memcached'
local tbl = require 'now.util.tbl'
local setmetatable = setmetatable
local paris = pairs

---use memcached for dao cache. need resty.memcached installed
module(...)

local _mt = { __index = _M }

---传递参数 {host, port, keepalive,  timeout}
function new(self, o)
	o = o or {}
	tbl.add_to_tbl(o, {
		keepalive = 200,
		timeout = 1000,
		pool = 100
	})
    return setmetatable(o, _mt)
end

---open socket
function open(self)
	self.mem_cls = memcached:new()
	self.mem_cls:set_timeout(self.timeout)
    local ok, err = self.mem_cls:connect(self.host,  self.port)
    if not ok then
        self.mem_cls = nil
    	return false, 'error to connect memcached, err='..err
    else
    	return true
    end
end

---get cache value by key
--@param #string key cache key
function get(self, key)
	if self.mem_cls ~= nil then
		local res, flags, err = self.mem_cls:get(key)
	    if err then
			self.mem_cls  = nil
	        return nil, err
	    end
	    if not res then
	        return nil, 'no value'
	    end
	    return res
	else
		return false, 'conn is not exist'
	end
end

---get values by keys
--@param #table keys cache keys
function mget(self, keys)
	if self.mem_cls ~= nil then
		return self::get(keys)
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
	if self.mem_cls ~= nil then
		local ok, err = self.mem_cls:set(key, val, expired)
		if err then
			self.mem_cls  = nil
			self.isopen = false
			return false, 'error to set memcache key='..key..' err='..err
		end
	else
		return false, 'conn is not exist'
	end
end

---set cache value from map table
--@param #table tbl cache table(k/v map)
--@param #int expired expired time(second)
function mset(self, tbl, expired)
    expired = expired or 0
	if self.mem_cls ~= nil then
		local ret = {}
		local err, flag, ret_err
		for k,v in paris(tbl) do
			flag, err = self:set(k, v, expired)
			ret[k] = {flag, err}
		end
		return ret
	else
		return false, 'conn is not exist'
	end
end

---del the cache key
--@param #string key cache key will be deleted
function del(self, key)
	if self.mem_cls ~= nil then
		local ok, err = self.mem_cls:delete(key)
		if err then
			self.mem_cls  = nil
            return false, 'error to delete memcache key='..key..' err='..err
		end
		return true
	else
		return false, 'conn is not exist'
	end
end

---del cache from table
--@param #table tbl key list
function mdel(self, tbl)
	if self.mem_cls ~= nil then
		local ret = {}
		local err, flag, ret_err
		for _,key in iparis(tbl) do
			local ok, err = self.mem_cls:delete(key)
			if err then
				self.mem_cls  = nil
	            return false, 'error to delete memcache key='..key..' err='..err
			end
			ret[k] = {flag, err}
		end
		return ret
	else
		return false, 'conn is not exist'
	end
end

---inc
--@param #string key cache key
--@param #int num incr number
function incr(self, key, num)
	num = num or 1
	if self.mem_cls ~= nil then
		local new_value, err = self.mem_cls:incr(key, num)
		if err then
			self.mem_cls  = nil
			self.isopen = false
            return false, 'error to incr memcache key=' .. key .. ' err='..err
		end
		return new_value
	else
		return false, 'conn is not exist'
	end
end

---close connection
function close(self)
	---always keep alive
	self.mem_cls:set_keepalive(self.keepalive, self.pool)
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable [' .. key .. ']')
    end
}

setmetatable(_M, class_mt)