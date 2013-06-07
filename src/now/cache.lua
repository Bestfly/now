local tbl = require 'now.util.tbl'
local setmetatable = setmetatable
local pairs = pairs

---cache class
module(...)

local _mt = { __index = _M }

---new instance
--@param #table o config
function new(self, o)
	o = o or {}
	tbl.addToTbl(o, {
		keepalive=200,
		timeout=1000
	})
	o['bufList'] = {}
	o['delList'] = {}
	o['ins'] = {}
    return setmetatable(o, _mt)
end

function _getIns(self, mdl)
	if self.ins[mdl] == nil then
		
	end
	return self.ins[mdl]
end

function _close(self)
	for k,v in pairs(self.ins) do
		self.mdls[k].close()
	end
end

---commit
function commit(self)
	for mdl, val in pairs(self.bufList) do
		local ins = self:_getIns(mdl)
		for k,v in pairs(val) do
			if v[2] > 0 then
				ins:set(key, v[1], v[2])
			end
		end
	end
	
	for mdl, val in pairs(self.delList) do
		local ins = self:_getIns(mdl)
		for k,v in pairs(val) do
			ins:del(key)
		end
	end
	
	self:_close()
end

---rollback
function rollback(self)
	self:_close()
end

---get cache value by key
--@param #string mdl module name
--@param #string key cache key
function get(self, mdl, key)
	if self.bufList[mdl] == nil then
		self.bufList[mdl] = {}
		if self.delList[key] == nil then
			return nil
		else
			local ins = self._getIns(mdl)
			local ret = ins:get(key)
			self.bufList[mdl][key] = {ret, -1}
			return ret
		end
	elseif self.bufList[key] ~= nil then
		return self.bufList[mdl][key][1]
	elseif self.delList[key] ~= nil then
		return nil
	else
		local ins = self._getIns(mdl)
		local ret = ins:get(key)
		self.bufList[mdl][key] = {ret, -1}
		return ret
	end
end

---get values by keys
--@param #string mdl module name
--@param #table keys cache keys
function mget(self, mdl, keys)
	local ret = {}
	local len = #keys
	if len == 0 then
		return ret
	end
	
	for i=1, len do
		ret[keys[i]] = self:get(mdl, keys[i])
	end
	
	return ret
end

---set cache value by key
--@param #string mdl module name
--@param #string key cache key
--@param #string val cache value string
--@param #int expired expired time(second)
function set(self, mdl, key, val, expired)
	if self.bufList[mdl] == nil then
		self.bufList[mdl] = {}
	end
	
    expired = expired or 0
    expired = abs(expired)
    self.bufList[mdl][key] = {val, expired}
    self.delList[mdl][key] = nil
end

---set cache value from map table
--@param #string mdl module name
--@param #table tbl cache table(k/v map)
--@param #int expired expired time(second)
function mset(self, mdl, tbl, expired)
	if self.bufList[mdl] == nil then
		self.bufList[mdl] = {}
	end
    expired = expired or 0
    expired = abs(expired)
	for k, v in pairs(tbl) do
    	self.bufList[mdl][k] = {v, expired}
    	self.delList[mdl][k] = nil
	end
end

---del the cache key
--@param #string mdl module name
--@param #string key cache key will be deleted
function del(self, mdl, key)
	if self.delList[mdl] == nil then
		self.delList[mdl] = {}
	end
	if self.bufKey[mdl] ~= nil and self.bufKey[mdl][key] ~= nil then
		self.bufKey[mdl][key] = nil
	end
   	self.delList[mdl][key] = 0
end

---del cache from table
--@param #string mdl module name
--@param #table tbl key list
function mdel(self, mdl, tbl)
	if self.delList[mdl] == nil then
		self.delList[mdl] = {}
	end
	if self.bufKey[mdl] == nil then
		self.bufKey[mdl] = {}
	end
	for i=1, #tbl do
		if self.bufKey[mdl][key] ~= nil then
			self.bufKey[mdl][key] = nil
		end
    	self.delList[mdl][k] = 0
	end
end

function inc(self, mdl, key, num)
	
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable [' .. key .. ']')
    end
}

setmetatable(_M, class_mt)