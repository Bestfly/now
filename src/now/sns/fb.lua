---facebook api for sns application
module("now.sns.fb",package.seeall)

local _cls = nao.sns.fb
local _mt = { __index = _cls}
local _base = require("now.base")

getmetatable(_cls).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end