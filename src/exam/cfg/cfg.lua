local setmetatable = setmetatable
local error = error
local pairs = pairs
module(...)

local data = {
    dev = { --开发环境
        cache = {
            object = false, query = false, cmd = false
        },
        log = {
            level = 0,
        }
    },

    test = { --测试环境
        cache = {
            object = false, query = false, cmd = false
        },
        log = {
            level = 0,
        }
    },

    auto = { --自动化测试
        cache = {
            object = false, query = false, cmd = false
        },
        log = {
            level = 0,
        }
    },

    pro = { --生产环境
        cache = {
            object = false, query = false, cmd = false
        },
        log = {
            level = 0,
        }
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