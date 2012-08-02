---view
module("now.view", package.seeall)
local base = require("now.base")

---return json string to browser
function json(data)
	
	ngx.print(base.json_encode(data))
end

---return jsonp string to browser
function jsonp(data)
end

---return html string to browser
function tpl(data, para)
end

---return xml string to browser
function xml(data)
end

---return excle file to browser. User can download it.
function excel(data)
end