local kt = require 'now.net.kt'
local setmetatable = setmetatable

---use Kyoto Tycoon as db
module(...)

local _mt = { __index = _M }

---初始化，需包含的参数为 {host='',port=''}
function new(self, o)
	o = o or {
		host = '127.0.0.1',
		port = 1978
	}
	o['kt'] = kt:new({
		host = o.host,
		port = o.port
	})
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