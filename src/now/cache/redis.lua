---use redis for dao cache. need resty.redis installed
module("now.cache.redis",package.seeall)

local _cls = now.cache.redis
local _mt = { __index = _cls}
local _redis = require("resty.redis")
local _tbl = require("now.util.tbl")

function new(self, o)
	o = o or {}
	_tbl.add_to_tbl(o, {
		keepalive=200,
		timeout=1000
	})
	o["isopen"] = false
    return setmetatable(o, _mt)
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

function incr(self, key, num)
end

function close(self)
end

getmetatable(_cls).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end