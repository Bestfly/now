local base = require 'now.base'
local sub = string.sub
local ceil = math.ceil
local tonumber = tonumber
local tostring = tostring

---一些时间相关的辅助函数
module(...)

local _dis = {
	w=3600*24*7, d=3600*24, h=3600, m=60, s=1
}

---计算时间间隔的秒数
--@param    dis     string  时间间隔，示例：2d 类型：w=周， d=天，h=小时，m=分钟，s=秒
--@return   int
function getDis(dis)
    local kind = sub(dis, -1)
    local num = tonumber(sub(dis, 1, -2))
    return ceil(num * _dis[kind])
end

---根据距离的间隔字符串
--@param #int dis 间隔的秒数
--@param #string kind 计算的类型w=周，d=天，h=小时，m=分钟，s=秒
function disStr(dis, kind)
	return dis / _dis[kind]
end

---比较date1比date2大多少
--@param #string date1 bigger date, format like  2012-01-01 00:00:00
--@param #string date2 smaller date, format like  2012-01-01 00:00:00
--@param #string kind what kind you will return. 'w'=week 'd'=day 'h'=hour 'm'=minute, 's'=second
function dateDiff(date1, date2, kind)
	local time1 = getTime(date1)
	local time2 = getTime(date2)
	if time1 < time2 then
		return - disStr(time1 - time2, kind)
	else
		return disStr(time1 - time2, kind)
	end
end

---日期增加
function dateAdd(date, dis)
	local time = getTime(date)
	time = time + getDis(dis)
	return os.date('%Y-%m-%d %H-%M-%S', time)
end

---获取当周的周一那天的日期，或者那天的0点0分的时间戳
--@param    time    int     一个时间戳,如果为nil则使用当前时间
--@param    type   string  返回类型，date=返回YYYY-mm-dd的时间格式，time=返回时间戳
--@usage	
--@return   string  返回的日期或者时间戳
function getMonday(time, type)
    if time == nil then
    	time = os.time() 
    end
    if type == nil then 
    	type = 'time'
    end
    
    local num = os.date('%w', time)  --当前周几，3=周三,0=周日
    if num == 0 then num = 6 end    --修改为我们习惯的时间
    if num ~= 1 then
        time = time - (num-1)*24*60*60
    end
    if type == 'date' then
        return os.date('%Y-%m-%d',time)
    else
        local y = os.date('%Y',time)
        local m = os.date('%m',time)
        local d = os.date('%d',time)
        return tostring( os.time({year=y,month=m,day=d}))
    end
end

---将yyyy-mm-dd[ hh:ii:ss]格式的时间转换成timestamp<br/>
-- 如果是yyyy-mm-dd，则默认为0点0分0秒
--@param    date    string      日期：yyyy-mm-dd[ hh:ii:ss]格式
--@return   int     timestamp
function getTime(date)
    local arr = base.split(date,' ')
    local d = base.split(arr[1],'-')
    
    local tbl = {
        year=tonumber(d[1]),month=tonumber(d[2]),day=tonumber(d[3])
    }
    if #arr == 2 then
        local t = base.split(arr[2],':')
        tbl['hour'] = tonumber(t[1])
        tbl['min'] = tonumber(t[2])
        tbl['sec'] = tonumber(t[3])
    else
        tbl['hour'] = 0
        tbl['min'] = 0
        tbl['sec'] = 0
    end
    return os.time(tbl)
end