---cache class
module("now.cache",package.seeall)

local mt = { __index = now.cache}

function new(self, o)
end

function commit(self)
end

function rollback(self)
end

function get(self, mdl, key)
end

function mget(self, mdl, keys)
end

function set(self, mdl, key, val, expired)
end

function mset(self, mdl, tbl, expired)
end

function del(self, mdl, key)
end

function mdel(self, smdl, tbl)
end

getmetatable(now.cache).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end