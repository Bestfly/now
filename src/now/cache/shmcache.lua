---use lua_shared_dict shm for dao cache
module("now.cache.shmcache",package.seeall)

local _cls = now.cache.shmcache
local _mt = { __index = _cls}

function new(self, o)
	
end

function get(self, key)
end

function mget(self, keys)
end

function set(self, key, val, expired)
end

function mset(self, tbl, expired)
end

function del(self, key)
end

function mdel(self, tbl)
end

getmetatable(_cls).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end