---use redis for dao cache. need resty.redis installed
module("now.cache.redis",package.seeall)

local _cls = now.cache.redis
local _mt = { __index = _cls}
local _redis = require("resty.redis")

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