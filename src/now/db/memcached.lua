---use memcached for dao cache. need resty.memcached installed
module("now.db.memcached",package.seeall)

local _cls = now.db.memcache
local _mt = { __index = _cls}
local _memcached = require("resty.memcached")
local _tbl = require("now.util.tbl")

function rollback(self)

end

function commit(self)
end

---传递参数 {host, port, keepalive,  timeout
function new(self, o)
	o = o or {}
	_tbl.add_to_tbl(o, {
		keepalive=200,
		timeout=1000
	})
	o["update_list"] = {}
	o["delete_list"] = {}
	o["isclose"] = true
    return setmetatable(o, _mt)
end

local function _open()
	if self.isclose then
		self.mem_cls = _memcached:new()
		self.mem_cls:set_timeout(self.timeout)
        local ok, err = self.mem_cls:connect(self.host,  self.port)
        if not ok then
            ngx.log(ngx.ERR,"failed to connect memcached at host="..self.host.." port="..self.port)
            self.mem_cls = nil
        else
			self.isclose = false
        end
	end
end

local function _get(self, key)
	local res, flags, err = self.mem_cls:get(key)
    if err then
		ngx.log(ngx.ERR,"error to get memcache key="..key.." err="..err)
		self.mem_cls  = nil
		self.isopen = false
        return nil
    end
    if not res then
        return nil
    end
    return res
end

function get(self, key)
	if type(key) == "string" then
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

function close()
	self.mem_cls:set_keepalive(0, self.keepalive)
end

getmetatable(_cls).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end