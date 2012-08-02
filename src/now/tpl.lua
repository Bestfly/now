---simple template compiled module
module("now.tpl", package.seeall)

---get result string from template file
--@param    tpl   string  template file name. also is a lua module
--@param    key   string  the key of the lua module
--@param    data  table   data for compiled
--@author   outrace@gmail.com
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