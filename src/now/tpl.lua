local ngx = ngx
local require = require
local error = error
local gsub = string.gsub

---一个简单的模板引擎。只支持lua语法和{#变量#}的替换
module(...)

local _tplFun = {}

---根据输入参数得到结果
--@param #string tpl 模板文件名称
--@param #string key 模板的key
--@param #table data 输入参数
--@return #string 内容结果
function tpl(tpl, key, data)
	tpl = ngx.ctx.request.game..'.tpl.'..tpl
	local ck = tpl..'_'..key
	
	if _tplFun[ck] == nil then
	    local mdl = _require(tpl)
	    if mdl == nil or mdl[key] == nil then
	    	error('tpl not exist tpl='..tpl..' key='..key)
	    end
	    local tstr = mdl[key]
	    
	    --只支持3种语法  <!--{ lua语法 }-->  {{替换内容}}
		local str = "local args = {...}\nlocal data = args[1]\nstr=[[\n"
		tstr = gsub(tstr, "<!%-%-{", "]]")
		tstr = gsub(tstr, "}%-%->", "\nstr=str..[[")
		tstr = gsub(tstr, "{#", "]]\nstr=str..")
		tstr = gsub(tstr, "#}", "\nstr=str..[[")
		str = str..tstr.."\n]]\nreturn str"
		_tplFun[ck] = loadstring(str)
	end
	
	return _tplFun[ck](data)
end