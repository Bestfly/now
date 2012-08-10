---Kyoto Tycoon http client
module("now.net.kt", package.seeall)

local _cls = now.net.kt
local _http = require("now.net.http")

---初始化，需包含的参数为 {host='',port=''}
function new(self, o)
	o = o || {
		host = "127.0.0.1",
		port = 80
	}
    return setmetatable(o, mt)
end

function _conn(self)
end

function _send_http(self,)
end



getmetatable(_cls).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end