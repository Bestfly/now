local tcp = ngx.socket.tcp
local random = math.random
local md5 = ngx.md5
local base = require 'now.base'
local log = require 'now.log'

---simple chat client, support group boardcast and p2p message
module(...)

local _mt = { __index = _M }
local _idle_time = 8000
local _conn_pool_size = 100

---初始化，需包含的参数为 {host='',port='',app='',code=''}
function new(self, o)
	o['sock'] = tcp()
	o['conn'] = false
	o['rec'] = ''
    return setmetatable(o, _mt)
end

local function _do_send(self, cmd)
	local sock = self.sock
    local cmd_str = base.jsonEncode(cmd)
    local len = 100000 + #cmd_str;
    local send_msg = tostring(len)..cmd_str
    local bytes, err = sock:send(send_msg)
    if not bytes then
        ngx.log(ngx.ERR, 'send chat msg error when send msg='..send_msg)
        return nil
    else
    	local len, err = sock:receive(6)
    	if not len then
        	ngx.log(ngx.ERR, 'can not get rec after login')
    	end
    	len = tonumber(len) - 10000
    	local data, err = sock:receive(len)
    	if not data then
        	ngx.log(ngx.ERR, 'can not get rec msg')
    	end
    	return base.json_decode(data)
    end
end

---发送信息到聊天服务器
--@param	to		接收方，空表示所有用户
--@param	msg		信息内容
function send(self, to, msg)
    local sock = self.sock
    if o['conn'] == false then
    	sock:settimeout(timeout)
    	local ok, err = sock:connect(self.host, self.port)
        if not ok then
            log.err('failed to connect chat svr,host='..self.host..' port='..self.port)
            return
        end
        o['conn'] = true
        
        --发送验证信息
        local rand_str = ngx.time()..tostring(random(100, 999))
        local crypt_code = md5(rand_str..self.code)
        local cmd = {cmd='login', uid='', app=self.app, code=rand_str..'|'..crypt_code}
    	local ret = self:do_send(cmd)
    end
    
    local cmd = {cmd='chat', from='', to=to, msg=msg}
    return self:_do_send(cmd)
end

---关闭sock
function close(self)
	--设置为size=100的连接池，8秒空闲则过期
	local ok, err = sock:setkeepalive(idle_time, conn_pool_size)
	if not ok then
		sock:close()
	    return
	end
end

local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable [' .. key .. ']')
    end
}

setmetatable(_M, class_mt)