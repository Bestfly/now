---data access object
module("now.dao",package.seeall)

local mt = { __index = now.dao}
local base = require("now.base")

function new(o)
end

function begin()
end

function commit()
end

function rollback()
end

function get(mdl, filter, page, order, get_one)
end

function mdf(mdl, filter, data)
end

function del(mdl, filter)
end

function find(mdl)
end

getmetatable(now.dao).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end