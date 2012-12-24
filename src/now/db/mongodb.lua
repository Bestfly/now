local base = require 'now.base'
local tbl = require 'now.util.tbl'
local setmetatable = setmetatable

module(...)

---
function _open(self)
end

---
function new(self, o)
	o = o or {}
	tbl.addToTbl(o, {
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

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable [' .. key .. ']')
    end
}

setmetatable(_M, class_mt)