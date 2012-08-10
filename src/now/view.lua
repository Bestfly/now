---view
module("now.view", package.seeall)
local _base = require("now.base")
local _tpl = require("now.tpl")

---return json string to browser
function json(data)
	ngx.header["Content-Type"] = 'text/html;charset=utf-8'
	ngx.header["Expires"] = '0'
	ngx.header["Cache-Control"] = 'public,must-revalidate,max-age=0,post-check=0,pre-check=0'
	ngx.print(_base.json_encode(data))
end

---return jsonp string to browser
function jsonp(data, callback)
	ngx.header["Content-Type"] = 'text/html;charset=utf-8'
	ngx.header["Expires"] = '0'
	ngx.header["Cache-Control"] = 'public,must-revalidate,max-age=0,post-check=0,pre-check=0'
	ngx.print(callback.."(".._base.json_encode(data)..")")
end

---return html string to browser
function tpl(data, tpl, key)
	ngx.header["Content-Type"] = 'text/html;charset=utf-8'
	ngx.header["Expires"] = '0'
	ngx.header["Cache-Control"] = 'public,must-revalidate,max-age=0,post-check=0,pre-check=0'
	ngx.print(_tpl.tpl(tpl, key, data))
end

---return xml string to browser
function xml(data)
	ngx.header["Content-Type"] = 'text/xml;charset=utf-8'
	ngx.header["Expires"] = '0'
	ngx.header["Cache-Control"] = 'public,must-revalidate,max-age=0,post-check=0,pre-check=0'
	
end

---return excle file to browser. User can download it.
function excel(data)
end

---download file
function download(filename, filepath, mimetype)
end