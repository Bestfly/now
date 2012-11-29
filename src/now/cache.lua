local _tbl = require 'now.util.tbl'

---cache class
module(...)
local _mt = { __index = _M }

function new(self, o)
	o = o or {}
	_tbl.add_to_tbl(o, {
		keepalive=200,
		timeout=1000
	})
	o['update_list'] = {}
	o['delete_list'] = {}
	o['mdls'] = {}
    return setmetatable(o, _mt)
end

function _get_mdl(self, mdl)
	if self.mdls[mdl] == nil then
		
	end
end

function _close(self)
	for k,v in pairs(self.mdls) do
		self.mdls[k].close()
	end
end

function commit(self)
	self:_close()
end

function rollback(self)
	self:_close()
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

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable [' .. key .. ']')
    end
}

setmetatable(_M, class_mt)