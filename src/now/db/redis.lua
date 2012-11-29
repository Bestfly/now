---use redis as a db. need resty.redis installed
module("now.db.redis",package.seeall)

local _cls = now.db.memcache
local _mt = { __index = _cls}
local _redis = require("resty.redis")

function rollback(self)
end

function commit(self)
end

---传递参数 {host, port, keepalive,  timeout
function new(self, o)
	o = o or {}
	o['keepalive']  = o['keepalive']  or 200
	o['timeout'] = o['timeout'] or 1000
	o["isopen"] = false
    return setmetatable(o, _mt)
end

function get(self, key)
end

function mdf(self, key, val)
end

function del(self, key)
end

getmetatable(_cls).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable [' .. key .. ']: '.. debug.traceback())
end