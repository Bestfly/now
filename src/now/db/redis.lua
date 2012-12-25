local redis = require 'resty.redis'
local type = type
local tbl = require 'now.util.tbl'
local base = require 'now.base'
local insert = table.insert

---use redis as a db. need resty.redis installed
module(...)

local _mt = { __index = _M }

---传递参数 {host, port, keepalive,  timeout
function new(self, o)
	o = o or {}
	tbl.addToTbl(o, {
		host = '127.0.0.1',
		port = 6379,
		keepalive = 200,
		timeout = 1000,
		pool = 100
	})
	o['isClose'] = true
	o['redisCls'] = nil
    return setmetatable(o, _mt)
end

function _open(self)
	if self.isClose then
		self.redisCls = redis:new()
		self.redisCls:set_timeout(self.timeout)
	    local ok, err = self.redisCls:connect(self.host,  self.port)
	    if err then
	    	base.error('error to connect redis server host=' .. self.host ..' port='..self.port..' err='..err)
	    end
	end
end

function rollback(self)
end

function commit(self)
end

---get data
--@param #string/table key redis key
function get(self, key)
	if type(key) == 'string' then
		local res, err = self.redisCls:get(key)
	    if err then
	    	base.error('error to get redis date host=' .. self.host ..' port='..self.port..' key='..key..' err='..err)
	    end
	    return base.jsonDecode(res)
	else
		local len = #key
		if len > 0 then
			local ret = {}
			for i=1, len do
				local res, err = self.redisCls:get(key)
			    if err then
			    	base.error('error to get redis data host=' .. self.host ..' port='..self.port..' key='..key..' err='..err)
			    end
			    insert(ret, base.jsonDecode(res))
			end
			return ret
		else
	    	base.error('key is empty table')
		end
	end
end

---mdf data
function mdf(self, key, val)
	
end

function del(self, key)
	if type(key) == 'string' then
		local res, err = self.redisCls:del(key)
	    if err then
	    	base.error('error to get redis date host=' .. self.host ..' port='..self.port..' key='..key..' err='..err)
	    end
	    return base.jsonDecode(res)
	else
		local len = #key
		if len > 0 then
			local ret = {}
			for i=1, len do
				local res, err = self.redisCls:del(key)
			    if err then
			    	base.error('error to del redis data host=' .. self.host ..' port='..self.port..' key='..key..' err='..err)
			    end
			    insert(ret, base.jsonDecode(res))
			end
			return ret
		else
	    	base.error('key is empty table')
		end
	end
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable [' .. key .. ']')
    end
}

setmetatable(_M, class_mt)