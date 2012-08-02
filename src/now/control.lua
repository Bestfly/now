---the main contoler
module("now.control", package.seeall)
local suf = ".do"
local base = require("now.base")
local dao = require("now.dao")
local session = require("now.session")
local cache = require("now.cache")
local cfg = require("app.cfg.cfg")

---main flow
function execute()
	local uri = string.sub(ngx.var.uri, 0, -(#suf+1))
	local arr = base.split(uri,"/") --/app/mdl/method.do

	--['应用名','模块名','方法名']
	
	ngx.ctx["dao"]= dao:new{
	}
	ngx.ctx["cache"] = cache:new{
	}
	ngx.ctx["session"] = session:new{
	}

	local flag,msg = pcall(fw.execute)
	if flag == false then
		ngx.say("system error")
		ngx.log(ngx.ERR,msg)
	end
end