local redis = require 'resty.redis'

---use redis as a db. need resty.redis installed
module(...)

local _mt = { __index = _M }

---传递参数 {host, port, keepalive,  timeout
function new(self, o)
	o = o or {}
	o['keepalive']  = o['keepalive']  or 200
	o['timeout'] = o['timeout'] or 1000
	o['isopen'] = false
    return setmetatable(o, _mt)
end

function rollback(self)
end

function commit(self)
end

function get(self, key)
end

function mdf(self, key, val)
end

function del(self, key)
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable [' .. key .. ']')
    end
}

setmetatable(_M, class_mt)