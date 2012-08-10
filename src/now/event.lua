---event
module("now.dao",package.seeall)

local _events = {
	["cmd.before"] = {},
	["cmd.after"] = {},
	["cmd.around"] = {},
	["cmd.error"] = {},
	["data.add"] = {},
	["data.mdf"] = {},
	["data.delete"] = {}
}

---注册事件监听。分cmd.before, cmd.after, cmd.around, cmd.error   data.add,  data.mdf,  data.delete
function regist(kind, callback)
	
end

---抛出事件
function dispatch(kind, data)

end

function remove(kind, callback)
end