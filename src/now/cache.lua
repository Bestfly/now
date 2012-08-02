---cache class
module("now.cache",package.seeall)

local mt = { __index = now.cache}

function new()
end

function commit()
end

function rollback()
end

function get(mdl, key)
end

function mget(mdl, keys)
end

function set(mdl, key, val, expired)
end

function mset(mdl, tbl, expired)
end

function del(mdl, key)
end

function mdel(mdl, tbl)
end

getmetatable(now.cache).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end