---提供简单的数据验证
module("now.util.val", package.seeall)


---内置的验证规则
local _rules = {
  str=function(rule, data) -- str-min-max
  	local len = #rule
  	local dlen = #data
  	local min = 0
  	if len > 1 then
  		min = tonumber(rule[2])
  	end
  	if len > 2 then
  		return dlen >= min and dlen <= tonumber(rule[3])
  	else
  		return dlen >= min
  	end
  end,
  
  int=function(rule, data)  -- int-min-max
  	
  end,
  
  float=function(rule, data) -- float-
  end,
  
  num=function(rule, data)  -- num-min-max
  end,
  
  alpha=function(rule, data) -- alpha-min-max
  end,
  
  alnum=function(rule, data) -- alnum-min-max
  end,
  
  date=function(rule, data)  --date
  end,
  
  datetime=function(rule, data) -- datetime
  end,
  
  ip=function(rule, data) -- ip
  end,
  
  mail=function(rule, data) -- mail
  end,
  
  url=function(rule, data) -- url
  end,
  
  cn_zip=function(rule, data) -- zip code in china
  end,
  
  cn_phone=function(rule, data) -- phone number in china
  end,
  
  cn_mobile=function(rule, data) -- mobile number in china
  end,
  
  qq=function(rule, data) --qq number
  end
}

function val(rule, data)
	if _rules[rule[1]] == nil then
		return false
	else
		return _rules[rule[1]](rule, data)
	end
end

---add user val rule. only add once
--@param #table rules user defiened rules. like {rule1 : function(rule, data) xxx end}
function add_val(rules)
	for k,v in pairs(rules) do
		_rules[k] = v
	end
end