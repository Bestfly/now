local http = require 'now.net.http'
local setmetatable = setmetatable

---qq api for sns application
module(...)

local _mt = { __index = _M }

---new instance {url='', port=80, appId'='', appKey=''}
function new(self, o)
	o = o or {
		port = 80
	}
    return setmetatable(o, _mt)
end

function api()
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable [' .. key .. ']')
    end
}

setmetatable(_M, class_mt)