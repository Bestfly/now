local pairs = pairs
local ipairs = ipairs
local insert = insert
local sort = sort
local getmetatable = getmetatable

---table相关的一些辅助函数
module(...)

---检查值是否存在于table中
--@param    tbl     table   对应的table
--@param    val     any     需要检查的value
--@usage	
--@return   true/false  
function inTbl(tbl, val)
    for n in pairs(tbl) do
        if tbl[n] == val then 
        	return true 
        end
    end
    return false
end

---将一个table的值增加到另外一个table中
--@param	tbl		table	目标表
--@param	newdata	table	被合并的table
--@param	force	boolean	是否强制合并
--@usage	
--@return void
function addToTbl(tbl, newdata, force)
	for n in pairs(newdata) do
		if force then
			tbl[n] = newdata[n]
		elseif tbl[n] == nil then
			tbl[n] = newdata[n]
		end
	end
end


---根据key重新排序table项
--@param    tbl     table   需要排序的map类型数组
--@usage	
--@return   table   已经根据key排序过的数组
function sortByKey(tbl)
	local tmp = {}
	for k in pairs(tbl) do
		insert(tmp,k)
	end
	sort(tmp)
	local sorted = {}
	
	for i = 1, #tmp do
		insert(sorted, tmp[i])
	end
	return sorted
end

---将k={}的数组转成纯数组
--@param    tbl     table   map类型的数组，key是string val是table
--@param    key     string  一个
--@usage	local mdl = require("nao.util.tbl") <br/>
--			local tbl = {k1={f1="v1",f2="v2",f3="v3"}}<br/>
--			local ret = mdl.map_to_arr(tbl})
--@return   table
function mapToArr(tbl, key)
    if key == nil then key = "id" end
    local newt = {}
    for k in pairs(tbl) do
        local v = tbl[k]
        v[key] = k
        insert(newt,v)
    end
    return newt
end

---一个新的pairs
function npairs(t)
	local oldpairs = pairs
	local mt = getmetatable(t)
	if mt==nil then
		return oldpairs(t)
	elseif type(mt.__pairs) ~= "function" then
		return oldpairs(t)
	end
	return mt.__pairs()
end

---对table进行拷贝
function copy(t)
	if type(t) ~= 'table' then return t end
	local res = {}
	for k,v in npairs(t) do
		if type(v) == 'table' then
			v = copy(v)
		end
		res[k] = v
	end
	return res
end

---移除table项中的某些字段，方便返回前台时候隐藏部分字段内容
--@param    tbl     table   需要进行筛选的表
--@param    fields  table   需要移除的字段
--@usage	local mdl = require("nao.util.tbl") <br/>
--			local tbl = {k1="v1",k2="v2",k3="v3"}<br/>
--			mdl.mvFields(tbl,{"k1","k2"})<br/>
--			local tbl2 = {{k1="v1",k2="v2"},{k1="vv1",k2="vv2"}}<br/>
--			mdl.mvFields(tbl2,{"k1"})
--@return   void
function mvFields(tbl, fields)
    if #tbl == 0 then --一般空的table和hash的table都会返回0
        for f in pairs(fields) do
            tbl[f] = nil
        end
    else
        for i = 1, #tbl do
        	for j = 1, #fields do
        		tbl[i][fields[j]] = nil
        	end
        end
    end
end

---只返回某tbl中的一部分字段
function fetchFields(tbl, fields)
	local ret = {}
	if #tbl == 0 then
        for f in pairs(fields) do
            ret[f] = tbl[f]
        end
	else
		for i = 1, pairs(tbl) do
			ret[i] = {}
			for f in pairs(fields) do
				ret[i][f] = k[f]
			end
		end
	end
	return ret
end

---检查是否是map类型，并且含有key的table。空的话我们返回false
function isMap(tbl)
	if #tbl == 0 then
		for _, _ in pairs(tbl) do
			return true
		end
	end
	return false
end

---格式化输出一个tbl
function dump(tbl)
	local ret = '{'
	if #tbl == 0 then
		for _, v in ipairs(tbl) do
			if type(v) == 'table' then
				ret = ret..dump(v)..",\n"
			else
				ret = ret..tostring(v)..",\n"
			end
		end
	else
		for k,v in npairs(tbl) do
			if type(v) == 'table' then
				ret = ret..k..'='..dump(v)..",\n"
			else
				ret = ret..k..'='..tostring(v)..",\n"
			end
		end
	end
	return ret..'}'
end

---get map table keys
function keys(tbl)
	local ret = {}
	if #tbl == 0 then
		for k,_ in pairs(tbl) do
			insert(ret, k)
		end
	else
		for i, _ in ipairs(tbl) do
			insert(ret, i)
		end
	end
	return ret
end