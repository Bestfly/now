---base cmd class
module("now.cmd", package.seeall)

local _cls = now.cache
local _mt = {__index = _cls}
local _base = require("now.base")

function new(self, o)
end

function _val(self, rule, data)
end

function _val_vo(self, mdl, vo, data)
end

function _ret(self, data, kind, para)
end

getmetatable(_cls).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end