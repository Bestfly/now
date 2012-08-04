---use memcached for dao cache. need resty.memcached installed
module("now.db.memcached",package.seeall)

local _cls = now.db.memcache
local _mt = { __index = _cls}
local _memcached = require("resty.memcached")

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

function close()
	self.mem_cls:set_keepalive(0, self.keepalive)
end

getmetatable(_cls).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end