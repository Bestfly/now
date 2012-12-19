local tbl = require 'now.util.tbl'
local ngx = ngx
local pairs = pairs
local abs = abs

---use ngx.shared for cache
module(...)

local _mt = { __index = _M }

---new instance {dict=''}
function new(self, o)
	o = o or {}
	tbl.addToTbl(o, {
		dict = 'dao'
	})
	if ngx.shared[o.dict] == nil then
		error('ngx.shared.'..o['dict']..' is not exist')
	end
	o.bufList = {}
	o.delList = {}
	o.shm = ngx.shared[o._dict]
    return setmetatable(o, _mt)
end

---get cache value by key
--@param #string key cache key
function get(self, key)
	if self.bufList[key] ~= nil then
		return self.bufList[key][2]
	elseif self.delList[key] ~= nil then
		return nil
	else
		local value = self.shm:get(key)
		if value ~= nil then
			self.bufList[key] = {value, -1}
		end
		return value
	end
end

---get values by keys
--@param #table keys cache keys
function mget(self, keys)
	local ret = {}
	local val
	for k in pairs(keys) do
		val = self:get(k)
		ret[k] = val
	end
	return ret
end

---set cache value by key
--@param #string key cache key
--@param #string val cache value string
--@param #int expired expired time(second)
function set(self, key, val, expired)
    expired = expired or 0
    expired = abs(expired)
    self.bufList[key] = {val, expired}
end

---set cache value from map table
--@param #table tbl cache table(k/v map)
--@param #int expired expired time(second)
function mset(self, tbl, expired)
    expired = expired or 0
    expired = abs(expired)
    
    local ret = {}
    for k, v in pairs(tbl) do
    	self.bufList[k] = {v, expired}
    end
    return ret
end

---del the cache key
--@param #string key cache key will be deleted
function del(self, key)
   	self.delList[key] = 0
end

---del cache from table
--@param #table tbl key list
function mdel(self, tbl)
    for _, k in pairs(tbl) do
   		self.delList[k] = 0
    end
end

---inc
--@param #string key cache key
--@param #int num incr number
function incr(self, key, num)
	num = num or 1
	local bk = self.bufList[key]
	if bk ~= nil then
		if bk[1] == '' then
			bk[1] = 0
		end
		bk[1] = bk[1] + num
		bk[2] = 0
		self.bufList[key] = bk
	else
		if self.delList[key] ~= nil then
			self.delList[key] = nil
		end
		
		local value = self.shm:get(key)
		if value == nil then
			self.bufList[key] = {num, 0}
		else
			self.bufList[key] = {tonumber(value) + num, 0}
		end
	end
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable [' .. key .. ']')
    end
}

setmetatable(_M, class_mt)