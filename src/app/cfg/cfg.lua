local setmetatable = setmetatable
local error = error
local pairs = pairs
module('app.cfg.cfg')
local data={
dev = {
suf = ".do",  --后缀
index = "home.index", --默认的控制器
},

test = {
},

pro = {
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