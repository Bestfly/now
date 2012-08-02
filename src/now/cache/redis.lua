---use redis for dao cache. need resty.redis installed
module("now.cache.redis",package.seeall)

local _cls = now.cache.redis
local _mt = { __index = _cls}
local _redis = require("resty.redis")

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