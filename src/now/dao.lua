---data access object
module("now.dao",package.seeall)

local _cls = now.dao
local _mt = { __index = _cls}
local _base = require("now.base")

function new(self, o)
	
end

function begin(self)
end

function commit(self)
end

function rollback(self)
end

function get(self, mdl, filter,  page,  order,  get_one)
end

function mdf(self, mdl, filter, data)
end

function del(self, mdl, filter)
end

function find(self, mdl)
end

getmetatable(_cls).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end