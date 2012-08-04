---simple chat client, support group message and p2p message
module("now.net.chat", package.seeall)

local _cls = now.net.chat
local _mt = { __index = _cls}
local _tcp = ngx.socket.tcp
local _idle_time = 8000
local _conn_pool_size = 100
local _random = math.random
local _md5 = ngx.md5
local _base = require("now.base")

---初始化，需包含的参数为 {host='',port='',app='',code=''}
function new(self, o)
	o["sock"] = _tcp()
	o["conn"] = false
	o["rec"] = ""
    return setmetatable(o, mt)
end

local function do_send(self, cmd)
	local sock = self.sock
    local cmd_str = _base.json_encode(cmd)
    local len = 100000 + #cmd_str;
    local send_msg = tostring(len)..cmd_str
    local bytes, err = sock:send(send_msg)
    if not bytes then
        ngx.log(ngx.ERR, "send chat msg error when send msg="..send_msg)
        return nil
    else
    	local len, err = sock:receive(6)
    	if not len then
        	ngx.log(ngx.ERR, "can not get rec after login")
    	end
    	len = tonumber(len) - 10000
    	local data, err = sock:receive(len)
    	if not data then
        	ngx.log(ngx.ERR, "can not get rec msg")
    	end
    	return _md5.json_decode(data)
    end
end

---发送信息到聊天服务器
--@param	to		接收方，空表示所有用户
--@param	msg		信息内容
function send(self, to, msg)
    local sock = self.sock
    if o["conn"] == false then
    	sock:settimeout(timeout)
    	local ok, err = sock:connect(self.host, self.port)
        if not ok then
            ngx.log(ngx.ERR,"failed to connect chat svr,host="..self.host.." port="..self.port)
            return
        end
        o["conn"] = true
        
        --发送验证信息
        local rand_str = ngx.time()..tostring(random(100, 999))
        local crypt_code = md5(rand_str..self.code)
        local cmd = {cmd="login", uid="", app=self.app, code=rand_str.."|"..crypt_code}
    	local ret = self::do_send(cmd)
    end
    
    local cmd = {cmd="chat", from="", to=to, msg=msg}
    return self::do_send(cmd)
end

---关闭sock
function close(self)
	--设置为size=100的连接池，8秒空闲则过期
	local ok, err = sock:setkeepalive(idle_time, conn_pool_size)
	if not ok then
		sock:close()
	    ngx.log(ngx.ERR,"fail to set keepalive")
	    return
	end
end

getmetatable(_cls).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '.. debug.traceback())
end