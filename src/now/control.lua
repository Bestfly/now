---the main contoler
local base = require 'now.base'
local log = require 'now.log'
local dao = require 'now.dao'
local session = require 'now.session'
local cache = require 'now.cache'
local sub = string.sub

module(...)

---main flow
function execute()
	local uri = sub(ngx.var.uri, 0, -(#suf+1))
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
		log.err(msg)
	end
end