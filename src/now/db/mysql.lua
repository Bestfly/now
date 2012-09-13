module("now.db.mysql", package.seeall)

local _cls = now.db.mysql
local _mt = { __index = _cls}
local _base = require("now.base")
local _mysql = require("resty.mysql")
local _tbl = require("now.util.tbl")

---根据SQL和对应参数，重新生成SQL。避免SQL注入
local function _buildSql(sql, para)
	if para then
		for k,v in pairs(para) do
			if type(v) == "string" then
				para[k] = "'"..v.."'"
			end
		end
		sql = string.gsub(sql, "%$(%w+)", para)
	end
	return sql
end

---打开SQL连接
function _open(self)
	if self.open == false then
		local db = _mysql:new()
		db:set_timeout(self.timeout) -- 1 sec
		
		local cfg = self.dbCfg
		local res, err, errno, sqlstate = db:connect{
			host = cfg.host,
			port = cfg.port,
			database = cfg.database,
			user = cfg.user,
			password = cfg.password,
			max_packet_size = 1024 * 1024
		}
		if not res then
			error("failed to connect: "..err)
		end
		
		self.db = db
		local res, err, errno, sqlstate = self.db:query("SET NAMES utf8")
		if not res then
			self.db:close()
			error("failed to query: SET NAMES utf8"..err)
		end
		local res, err, errno, sqlstate = self.db:query("SET AUTOCOMMIT=0")
		if not res then
			self.db:close()
			error("failed to query: SET AUTOCOMMIT=0 err="..err)
		end
		
		self.open = true
	end
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
		--local res, err, errno, sqlstate = self.db:query("SET AUTOCOMMIT=0")
		--if not res then
		--	error("can")
		--end
		self.begin = true
	end
end

---提交事务
function commit(self)
	if self.begin then
		local res, err, errno, sqlstate = self.db:query("COMMIT")
		if not res then
			self.db:close()
			error("can not commit err="..err)
		end
	end
	--self.db:close()
	self.db:set_keepalive(self.keepalive, self.pool)
end

---回滚事务
function rollback(self)
	if self.begin then
		--local res, err, errno, sqlstate = self.db:query("ROLLBACK")
		--if not res then
		--end
	end
	--self.db:close()
	self.db:set_keepalive(self.keepalive, self.pool)
end

---发起一次查询，并返回结果
function query(self, sql, para)
	self:_open()
	sql = _buildSql(sql, para)
	ngx.say(sql)
	local res, err, errno, sqlstate = self.db:query(sql)
	if not res then
		error("query sql err="..err.." sql="..sql)
	else
		return res
	end
end

---执行一次操作，得到影响的行数
function execute(self, sql, para)
	self:_open()
	self:_begin()
	sql = _buildSql(sql, para)
	local res, err, errno, sqlstate = self.db:query(sql)
	ngx.say(sql)
	if not res then
		error("execute sql err="..err.." sql="..sql)
	else
		return res.affected_rows
	end
end

getmetatable(_cls).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end