---the main contoler
module("now.control", package.seeall)

local _base = require("now.base")
local _dao = require("now.dao")
local _session = require("now.session")
local _cache = require("now.cache")

---main flow
function execute()
	local uri = string.sub(ngx.var.uri, 0, -(#suf+1))
	local arr = base.split(uri,"/") --/app/mdl/method.do

	--['应用名','模块名','方法名']
	
	ngx.ctx["dao"]= _dao:new{
	}
	ngx.ctx["cache"] = _cache:new{
	}
	ngx.ctx["session"] = _session:new{
	}

	local flag,msg = pcall(fw.execute)
	if flag == false then
		ngx.say("system error")
		ngx.log(ngx.ERR,msg)
	end
end