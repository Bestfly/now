---use memcached for dao cache. need resty.memcached installed
module("now.cache.memcached",package.seeall)

local _cls = now.cache.memcache
local _mt = { __index = _cls}
local _memcached = require("resty.memcached")

function new(o)
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