---mysql class. need resty.mysql installed
module("now.db.mysql",package.seeall)

local _cls = now.db.mysql
local _mt = { __index = _cls}
local _base = require("now.base")

local funciton _open()
end

function new(self, o)
end

function begin(self)
end

function commit(self)
end

function rollback(self)
end

function query(self, sql)
end

function execute(self, sql)
end

getmetatable(_cls).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end