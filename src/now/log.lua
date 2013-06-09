local ngx = ngx

---log api
--暂时先直接使用ngx的log
module(...)

DEBUG = ngx.DEBUG
INFO = ngx.INFO
NOTICE = ngx.NOTICE
WARN = ngx.WARN
ERR = ngx.ERR
CRIT = ngx.CRIT

level = ngx.WARN

function debug(msg)
	ngx.log(ngx.DEBUG, msg)
end

function info(msg)
	ngx.log(ngx.INFO, msg)
end

function notice(msg)
	ngx.log(ngx.NOTICE, msg)
end

function warn(msg)
	ngx.log(ngx.WARN, msg)
end

function err(msg)
	ngx.log(ngx.ERR, msg)
end

function crit(msg)
	ngx.log(ngx.CRIT, msg)
end