---base cmd class
module("now.cmd",package.seeall)

local mt = {__index = now.cache}
local base = require("now.base")

function new()
end

function _val()
end

function _val_vo()
end

function _ret()
end

getmetatable(now.cmd).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end