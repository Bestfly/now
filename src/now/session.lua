---simple session module
module("now.session", package.seeall)

local _cls = now.session
local _mt = {__index = _cls}
local _tbl = require("now.util.tbl")
local _base = require("now.base")

--- o like {to_cookie=true/false, cookie_name='now', cookie_domain='/', cookie_path='/', cookie_expire=0}
function new(self, o)
	o = o or {}
	_tbl.add_to_tbl(o, {
		_init = false,
		_data = {},
		cookie_name = "_nowsess",
		cookie_domain = "",
		cookie_path = "/",
		cookie_expire = 0
	})
    return setmetatable(o, _mt)
end

--- init session
function init_session(self, str)
	local _s = str
	if self.to_cookie then
		
	end
end

--- get session data by key
function get(self, key)
	return self._data[key]
end

--- set session data
function set(self, key, val)
	self._data[key] = val
	return self:_save()
end

--- delete session key
function del(self, key)
	self._data[key] = nil
	return self:_save()
end

--- destroy session
function destroy(self)
	self._data = {}
	return self:_save()
end

-- save session data
function _save(self)
	local json_str = _base.json_encode(self._data)
	return json_str
end

getmetatable(_cls).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end