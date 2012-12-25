local memcached = require 'resty.memcached'
local tbl = require 'now.util.tbl'
local base = require 'now.base'

---use memcached for dao cache. need resty.memcached installed
module(...)

local _mt = { __index = _M }

--- {host, port, keepalive,  timeout, pool}
function new(self, o)
	o = o or {}
	tbl.addToTbl(o, {
		host = '127.0.0.1',
		port = 11211,
		keepalive = 200,
		timeout = 1000,
		pool = 100
	})
	o['getList'] = {}
	o['updateList'] = {}
	o['deleteList'] = {}
	o['isclose'] = true
    return setmetatable(o, _mt)
end

---rollback
function rollback(self)
	-- do nothing
end

---commit
function commit(self)

end

---connect memcached server
local function _open(self)
	if self.isclose then
		self.memCls = memcached:new()
		self.memCls:set_timeout(self.timeout)
        local ok, err = self.memCls:connect(self.host,  self.port)
        if not ok then
            self.memCls = nil
            base.error('error to connect memcached server host='..self.host..' port='..self.port)
        else
			self.isclose = false
        end
	end
end

local function _get(self, key)
	local res, flags, err = self.memCls:get(key)
    if err then
		self.memCls  = nil
		self.isopen = false
        base.error('error to connect memcached server host='..self.host..' port='..self.port)
    end
    return base.jsonDecode(res)
end

function get(self, key)
	if type(key) == 'string' then
		return self::_get(key)
	else
		return self::_get(key)
	end
end

function mdf(self, key, val)
	if type(key) == "string" then
	else
	end
end

function del(self, key)
	if type(key) == "string" then
	else
	end
end

function close(self)
	self.memCls:set_keepalive(0, self.keepalive)
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable [' .. key .. ']')
    end
}

setmetatable(_M, class_mt)