---mysql class. need resty.mysql installed
module("now.db.mysql",package.seeall)

local _cls = now.db.mysql
local _mt = { __index = _cls}
local _base = require("now.base")

function new()
end

function begin()
end

function commit()
end

function rollback()
end

function query()
end

function execute()
end

getmetatable(_cls).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end