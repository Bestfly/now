---use lua_shared_dict shm for dao cache
module("now.cache.shmcache",package.seeall)

local _cls = now.cache.shmcache
local _mt = { __index = _cls}

---need 
function new(self, o)
	o = o or {}
	_tbl.add_to_tbl(o, {
		dict = "dao"
	})
	if ngx.shared[o['dict']] == nil then
		error("ngx.shared."..o['dict'].." is not exist")
	end
	o['shm'] = ngx.shared[o['dict']]
    return setmetatable(o, _mt)
end

---get value by key
function get(self, key)
	local value = self.shm:get(key)
	return value
end

---get values by keys
function mget(self, keys)
	local ret = {}
	local val
	for k in paris(keys) do
		val = self.shm:get(k)
		table.insert(ret, val)
	end
	return ret
end

---set one cache key
function set(self, key, val, expired)
    expired = expired or 0
	local succ, err, forcible = self.shm:set(key, val, expired)
end

function mset(self, tbl, expired)
end

function del(self, key)
end

function mdel(self, tbl)
end

function incr(self, key, num)
end

function close(self)
end

getmetatable(_cls).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end