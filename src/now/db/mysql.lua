local pairs = pairs
local gsub = string.gsub
local type = type
local error = error

local base = require 'now.base'
local mysql = require 'resty.mysql'
local tbl = require 'now.util.tbl'
local ngx = ngx

module(...)

local _mt = { __index = _M }

---build sql string with para
--@param #string sql sql string
--@param #table para
local function _buildSql(sql, para)
    if para then
        for k, v in pairs(para) do
            if type(v) == 'string' then
                para[k] = "'"..ngx.quote_sql_str(v).."'"
            end
        end
        sql = gsub(sql, "%$(%w+)", para)
    end
    return sql
end

---open mysql connection
--@function [parent=#gnow.mysql] _open
local function _open(self)
    if self._open == false then
        local db = mysql:new()
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

        self._open = true
    end
end

---新建一个mysql示例
--@function [parent=#gnow.mysql] new
--@param #table o 初始化参数，比如包含_dbCfg这个参数
function new(self, o)
    o = o or {}
    tbl.addToTbl(o, {
        keepalive=1500,
        timeout=4000,
        pool=256
    })
    o._open = false
    o._begin = false
    return setmetatable(o, _mt)
end

---开启事务
--@function [parent=#gnow.mysql] _begin
local function _begin(self)
    if self._begin == false then
        --local res, err, errno, sqlstate = self.db:query("SET AUTOCOMMIT=0")
        --if not res then
        --	error("can")
        --end
        self._begin = true
    end
end

---提交事务
--@function [parent=#gnow.mysql] commit
function commit(self)
    if self._begin then
        local res, err, errno, sqlstate = self.db:query("COMMIT")
        if not res then
            self.db:close()
            error("can not commit err="..err)
        end
    end
    self.db:set_keepalive(self.keepalive, self.pool)
end

---回滚事务
--@function [parent=#gnow.mysql] rollback
function rollback(self)
    if self._begin then
        --local res, err, errno, sqlstate = self.db:query("ROLLBACK")
        --if not res then
        --end
    end
    self.db:set_keepalive(self.keepalive, self.pool)
end

---发起一次查询，并返回结果
--@function [parent=#gnow.mysql] query
--@param #string sql 发送的SQL语句
--@param #table para SQL语句中需要替换变量的值
--@return #table SQL返回的数据集合
function query(self, sql, para)
    self:_open()
    sql = _buildSql(sql, para)
    local res, err, errno, sqlstate = self.db:query(sql)
    if not res then
        error("query sql err="..err.." sql="..sql)
    else
        return res
    end
end

---执行一次操作，得到影响的行数
--@function [parent=#gnow.mysql] execute
--@param #string sql 发送的SQL语句
--@param #table para SQL语句中需要替换变量的值
--@return #int 影响到的行数，不要以此作为执行对错的标记
function execute(self, sql, para)
    self:_open()
    self:_begin()
    sql = _buildSql(sql, para)
    local res, err, errno, sqlstate = self.db:query(sql)
    if not res then
        error("execute sql err="..err.." sql="..sql)
    else
        return res.affected_rows
    end
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable [' .. key .. ']')
    end
}

setmetatable(_M, class_mt)