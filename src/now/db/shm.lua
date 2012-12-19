
---use redis as a db. need resty.redis installed
module(...)

local _mt = { __index = _M }

---传递参数 {app='应用名称',dict='shm中的字典前缀,默认为app_'}
function new(self, o)
	_tbl.addToTbl(o, {
		dict = 'app_'
	})
	if ngx.shared[o.dict] == nil then
		error('ngx.shared.'..o['dict']..' is not exist')
	end
	o.bufList = {}
	o.delList = {}
	o.shm = ngx.shared[o._dict]
    return setmetatable(o, _mt)
end

function rollback(self)
end

function commit(self)
end

function get(self, key)
end

function mdf(self, key, val)
end

function del(self, key)
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable [' .. key .. ']')
    end
}

setmetatable(_M, class_mt)