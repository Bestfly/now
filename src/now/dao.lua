local base = require 'now.base'
local error = error

---data access object
module(...)
local _mt = { __index = _M }

function new(self, o)
	
end

function begin(self)
end

function commit(self)
end

function rollback(self)
end

function get(self, mdl, filter,  page,  order,  getOne)
end

function mdf(self, mdl, filter, data)
end

function del(self, mdl, filter)
end

function find(self, mdl)
end


local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable [' .. key .. ']')
    end
}

setmetatable(_M, class_mt)