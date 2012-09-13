---进行事件处理
module("now.event", package.seeall)

local _this = gnow.event
_this.event = {
	cmd_before = {},	--命令执行前
	cmd_after = {},		--命令执行后
	cmd_error = {},		--错误执行前
	ret_before = {},	--进行结果返回前
	
	data_add_before = {},		--数据新增前
	data_add_after = {},		--数据新增后
	data_mdf_before = {},		--更改发生前
	data_mdf_after = {},		--更改发生后
	data_del_before = {},		--删除发生前
	data_del_after = {}			--删除发生后
}

---注册事件监听
--@param #string kind 监听的类型
--@param #function callback 回调函数
function register(kind, callback)
	if _this.event[kind] == nil then
		return
	end
	table.insert(_this.event[kind], callback)
end

---触发事件
--@param #string kind 监听的类型
function call(kind, ...)
	if _this.event[kind] == nil then
		return
	end
	
	for _, cb in ipairs(_this.event[kind]) do
		cb(...)
	end
end