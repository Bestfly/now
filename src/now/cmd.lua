---base cmd class
local base = require("now.base")

module(...)

function new(self, o)
end

function _val(self, rule, data)
end

function _val_vo(self, mdl, vo, data)
end

function _ret(self, data, kind, para)
end

getmetatable(_cls).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable [' .. key .. ']: '.. debug.traceback())
end