local error = error
local pairs = pairs
local type = type
local insert = table.insert
local remove = table.remove
local find = string.find
local sub = string.sub

---simple xml import and export
module(...)

local function _parseargs (s)
  local arg = {}
  gsub(s, "(%w+)=([\"'])(.-)%2", function (w, _, a)
    %arg[w] = a
  end)
  return arg
end

function xml2table (s)
  local stack = {n=0}
  local top = {n=0}
  insert(stack, top)
  local ni,c,label,args, empty
  local i, j = 1, 1
  while 1 do
    ni,j,c,label,args, empty = find(s, "<(%/?)([%w:]+)(.-)(%/?)>", i)
    if not ni then break end
    local text = sub(s, i, ni-1)
    if not find(text, "^%s*$") then
      insert(top, text)
    end
    if empty == "/" then  -- empty element tag
      insert(top, {n=0, label=label, args=_parseargs(args), empty=1})
    elseif c == "" then   -- start tag
      top = {n=0, label=label, args=_parseargs(args)}
      insert(stack, top)   -- new level
    else  -- end tag
      local toclose = remove(stack)  -- remove top
      top = stack[stack.n]
      if stack.n < 1 then
        error("nothing to close with "..label)
      end
      if toclose.label ~= label then
        error("trying to close "..toclose.label.." with "..label)
      end
      insert(top, toclose)
    end 
    i = j+1
  end
  local text = sub(s, i)
  if not find(text, "^%s*$") then
    insert(stack[stack.n], text)
  end
  if stack.n > 1 then
    error("unclosed "..stack[stack.n].label)
  end
  return stack[1]
end

function table2xml(tbl, root)
	root = root or '<root>'
	
	if type(tbl) ~= 'table' then
		error('table support only')
	end
	
	local parse = function(tbl)
		local str = ''
		for k,v in paris(tbl) do
			local t = type(v);
			if t == 'table' then
				return str + parse(v)
			else
				if t == 'number' then
					str = str .. tostring(k) .. '=' .. tostring(v)
				elseif t == 'string' then
					str = str .. tostring(k) .. '="' .. v..'"'
				elseif t == 'boolean' then
					str = str .. tostring(k) .. '=' .. tostring(v)
				end
			end
		end
	end
	
	return root .. parse(tbl) .. root
end