---use memcached for dao cache. need resty.memcached installed
module("now.cache.memcached",package.seeall)

local _cls = now.cache.memcache
local _mt = { __index = _cls}
local _memcached = require("resty.memcached")

---传递参数 {host, port, keepalive,  timeout
function new(self, o)
	o = o or {}
	_tbl.add_to_tbl(o, {
		keepalive=200,
		timeout=1000
	})
	o["isopen"] = false
    return setmetatable(o, _mt)
end

---open socket
function _open(self)
	if self.isopen == false then
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

---get cache value by key
function get(self, key)
	self:_open()
	if self.isopen then
		local res, flags, err = self.mem_cls:get(key)
        if err then
			self.mem_cls  = nil
			self.isopen = false
            return nil, err
        end
        if not res then
            return nil, "no value"
        end
        return res
	end
	return nil, "can not connect to memcached server"
end

---get values by keys
function mget(self, keys)
	return self::get(keys)
end

function set(key, val, expired)
	self:_open()
	if self.isopen then
		local ok, err = self.mem_cls:set(key, val, expired)
		if err then
			self.mem_cls  = nil
			self.isopen = false
			return false, "error to set memcache key="..key.." err="..err
		end
	end
	return true, "can not connect to memcached server"
end

function mset(tbl, expired)
	local ret = {}
	local err, flag, ret_err
	for k,v in paris(tbl) do
		flag, err = self:set(k, v, expired)
		ret[k] = {flag, err}
	end
	return ret
end

function del(key)
	self:_open()
	if self.isopen then
		local ok, err = self.mem_cls:delete(key)
		if err then
			self.mem_cls  = nil
			self.isopen = false
            return false, "error to delete memcache key="..key.." err="..err
		end
	end
	return true, "can not connect to memcached server"
end

function mdel(tbl)
	local ret = {}
	local err, flag, ret_err
	for k,v in paris(tbl) do
		flag, err = self:del(k, v, expired)
		ret[k] = {flag, err}
	end
	return ret
end

function incr(self, key, num)
	self:_open()
	if self.isopen then
		local new_value, err = self.mem_cls:incr(key, num)
		if err then
			ngx.log(ngx.ERR,
			self.mem_cls  = nil
			self.isopen = false
            return nil, "error to incr memcache key="..key.." err="..err
		end
		return new_value
	end
	return nil, "can not connect to memcached server"
end

function close()
	---always keep alive
	self.mem_cls:set_keepalive(0, self.keepalive)
end

getmetatable(_cls).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end