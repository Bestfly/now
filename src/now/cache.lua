local tbl = require 'now.util.tbl'
local setmetatable = setmetatable

---cache class
module(...)

local _mt = { __index = _M }

function new(self, o)
	o = o or {}
	tbl.addToTbl(o, {
		keepalive=200,
		timeout=1000
	})
	o['update_list'] = {}
	o['delete_list'] = {}
	o['mdls'] = {}
    return setmetatable(o, _mt)
end

function _get_mdl(self, mdl)
	if self.mdls[mdl] == nil then
		
	end
end

function _close(self)
	for k,v in pairs(self.mdls) do
		self.mdls[k].close()
	end
end

---commit
function commit(self)
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
	local ins = self._get_mdl(mdl)
	return ins.get(key)
end

---get values by keys
--@param #string mdl module name
--@param #table keys cache keys
function mget(self, mdl, keys)
	local ins = self._get_mdl(mdl)
	return ins.mget(keys)
end

---set cache value by key
--@param #string mdl module name
--@param #string key cache key
--@param #string val cache value string
--@param #int expired expired time(second)
function set(self, mdl, key, val, expired)
	local ins = self._get_mdl(mdl)
	return ins.set(key, val, expired)
end

---set cache value from map table
--@param #string mdl module name
--@param #table tbl cache table(k/v map)
--@param #int expired expired time(second)
function mset(self, mdl, tbl, expired)
	local ins = self._get_mdl(mdl)
	return ins.mset(tbl, expired)
end

---del the cache key
--@param #string mdl module name
--@param #string key cache key will be deleted
function del(self, mdl, key)
	local ins = self._get_mdl(mdl)
	return ins.del(key)
end

---del cache from table
--@param #string mdl module name
--@param #table tbl key list
function mdel(self, mdl, tbl)
	local ins = self._get_mdl(mdl)
	return ins.mdel(tbl)
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable [' .. key .. ']')
    end
}

setmetatable(_M, class_mt)