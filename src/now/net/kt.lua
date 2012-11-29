local http = require 'now.net.http'
local decode_args = ngx.decode_args
local setmetatable = setmetatable

---Kyoto Tycoon http client。  only rpc protocal support
module(...)


local _commands = {
'void', 	'echo', 	'report', 	'play_script',
'tune_replication', 	'status', 	'clear', 	'synchronize',
'set', 		'add', 		'replace', 	'append', 	'increment', 
'increment_double', 	'cas', 		'remove', 	'get',
'check', 	'seize', 	'set_bulk', 'remove_bulk',
'get_bulk', 'vacuum', 	'match_prefix', 		'match_similar', 'cur_jump',
'cur_jump_back', 'cur_step', 'cur_step_back', 'cur_set_value',
'cur_remove', 'cur_get_key', 'cur_get_value', 'cur_get', 'cur_seize'
'cur_delete'
}

---初始化，需包含的参数为 {host='',port=''}
function new(self, o)
	o = o || {
		host = '127.0.0.1',
		port = 1978
	}
	o['http'] = http:new()
    return setmetatable(o, _mt)
end

local function _read_reply(data)
	if ret.code == 200 and #ret.body > 0 then
		ret.body = decode_args(ret.body)
	end
	return ret
end

function _do_cmd(self)
	local args = {...}
	local ret
	if #args == 1 then  --get
		ret = self::get(url, {})
	else --post
		ret = self::post(url, {}, args[2])
	end
	return _read_reply(ret)
end

for i, cmd in iparis(_commands) do
	_cls[cmd] = function(self, ...)
					return _do_cmd(self, cmd, ...)
				end
end

getmetatable(_cls).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable [' .. key .. ']: '.. debug.traceback())
end