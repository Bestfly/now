local setmetatable = setmetatable
local error = error
local pairs = pairs
module(...)

local data = {
    suf = '.do', --后缀
    index = 'home.index', --默认的控制器
    cmdCache = {  --cmd的cache列表
        ['exam.getUser']=10     --针对exam/getUser这个请求，根据参数不一样，缓存10秒
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