local setmetatable = setmetatable
local error = error
local pairs = pairs
module('app.cfg.db')
			
local data={
dev = {
	user={driver='mysql', host='127.0.0.1', port=3306, database='now_user', user='root', password=''},
},

test = {
	user={driver='mysql', host='127.0.0.1', port=3306, database='now_user', user='root', password=''},
},

auto = {
    user={driver='mysql', host='127.0.0.1', port=3306, database='now_user', user='root', password=''},
},

pro = {
	user={driver='mysql', host='127.0.0.1', port=3306, database='now_user', user='root', password=''},
}

}
local proxy = {}
setmetatable(proxy, {
   __index = data,
   __pairs = function() return pairs(data) end,
   __newindex = function(t, k, v)
            error('table can not modify in runtime')
       end
})
return proxy