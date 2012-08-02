---use lua_shared_dict shm for dao cache
module("now.cache.shmcache",package.seeall)

local _cls = now.cache.shmcache
local _mt = { __index = _cls}

function new()
end

function get(key)
end

function mget(keys)
end

function set(key, val, expired)
end

function mset(tbl, expired)
end

function del(key)
end

function mdel(tbl)
end

getmetatable(_cls).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end