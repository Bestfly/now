module("now.db.mongodb", package.seeall)

local _cls = now.db.mongodb
local _mt = { __index = _cls}
local _base = require("now.base")
local _mysql = require("resty.mysql")
local _tbl = require("now.util.tbl")

---打开SQL连接
function _open(self)
end

---新建一个mysql示例
function new(self, o)
	o = o or {}
	_tbl.addToTbl(o, {
		keepalive=1500,
		timeout=4000,
		pool=256
	})
	o.open = false
	o.begin = false
    return setmetatable(o, _mt)
end

---开启事务
function _begin(self)
	if self.begin == false then
		self.begin = true
	end
end

---提交事务
function commit(self)
end

---回滚事务
function rollback(self)
end

---发起一次查询，并返回结果
function query(self, sql, para)
end

---执行一次操作，得到影响的行数
function execute(self, sql, para)
end

getmetatable(_cls).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end