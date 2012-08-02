---提供简单的数据验证
module("now.util.val", package.seeall)

---内置的验证规则
local _rules = {
  str : function(rule, data)
  end,
  
  int : function(rule, data)
  end,
  
  alpha : function(rule, data)
  end,
}

function val(rule, data)
	
end

---add user val rule. only add once
--@param #table rules user defiened rules. like {rule1 : function(rule, data) xxx end}
function add_val(rules)
	for k,v in pairs(rules) do
		_rules[k] = v
	end
end