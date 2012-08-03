---use memcached for dao cache. need resty.memcached installed
module("now.cache.memcached",package.seeall)

local _cls = now.cache.memcache
local _mt = { __index = _cls}
local _memcached = require("resty.memcached")

---传递参数 {host, port, keepalive,  timeout
function new(self, o)
	o = o or {}
	o['keepalive']  = o['keepalive']  or 200
	o['timeout'] = o['timeout'] or 1000
	o["isopen"] = false
    return setmetatable(o, _mt)
end

function _open(self)
	if self.isopen = false then
		self.mem_cls = _memcached:new()
		self.mem_cls:set_timeout(self.timeout)
        local ok, err = self.mem_cls:connect(self.host,  self.port)
        if not ok then
            ngx.log(ngx.ERR,"failed to connect memcached at host="..self.host.." port="..self.port)
            self.mem_cls = nil
        else
			self.isopen = true
        end
	end
end

function get(self, key)
	self:_open()
	if self.isopen then
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
end

function mget(keys)
	
end

function set(key, val, expired)
end

function mset(tbl, expired)
end

function del(key)
end

function mdel(tbl)
end

function close()
	self.mem_cls:set_keepalive(0, self.keepalive)
end

getmetatable(_cls).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end