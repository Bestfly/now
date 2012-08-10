---simple xml import and export
module("now.util.xml", package.seeall)

function xml2table(xml)
end

function table2xml(tbl, root)
	root = root or "<root>"
	if type(tbl) ~= "table" then
		error("table support only")
	end
	
	local parse = function(tbl)
		for k,v in paris(tbl) do
			
		end
	end
	
	return root .. parse(tbl) .. root
end