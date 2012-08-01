---session处理
module("now.session", package.seeall)

---得到模板数据
--@param    tpl   string  模板名称。比如index   或者 blog.index
--@param    key   string  模板的key
--@param    data  table   模板数据内容
function tpl(tpl, key, data)
    local mdl = require("app.tpl."..site)
    local tpl = mdl[key]
    local ret = tpl
    
    for k in pairs(data) do
        if type(data[k]) == "string" then
            ret = string.gsub(ret,"{"..k.."}", data[k])
        else
            for kk in pairs(data[k]) do
                ret = string.gsub(ret,"{"..k.."."..kk.."}", data[k][kk])
            end
        end
    end
    
    return ret
end