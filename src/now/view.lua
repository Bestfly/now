local _base = require "now.base"
local _tpl = require "now.tpl"
local _ngx = ngx

---view
module("...")

---return json string to browser
--@param #table data out put data
function json(data)
	_ngx.header["Content-Type"] = 'text/html;charset=utf-8'
	_ngx.header["Expires"] = '0'
	_ngx.header["Cache-Control"] = 'public,must-revalidate,max-age=0,post-check=0,pre-check=0'
	_ngx.print(_base.json_encode(data))
end

---return jsonp string to browser
--@param #table data out put data
--@param #string callback javascript callback function name
function jsonp(data, callback)
	_ngx.header["Content-Type"] = 'text/html;charset=utf-8'
	_ngx.header["Expires"] = '0'
	_ngx.header["Cache-Control"] = 'public,must-revalidate,max-age=0,post-check=0,pre-check=0'
	_ngx.print(callback.."(".._base.json_encode(data)..")")
end

---return html string to browser
--@param #table data out put data
--@param #string tbl template module name
--@param #string key key in the template module
function tpl(data, tpl, key)
	_ngx.header["Content-Type"] = 'text/html;charset=utf-8'
	_ngx.header["Expires"] = '0'
	_ngx.header["Cache-Control"] = 'public,must-revalidate,max-age=0,post-check=0,pre-check=0'
	_ngx.print(_tpl.tpl(tpl, key, data))
end

---return xml string to browser
--@param #table data out put data
function xml(data)
	_ngx.header["Content-Type"] = 'text/xml;charset=utf-8'
	_ngx.header["Expires"] = '0'
	_ngx.header["Cache-Control"] = 'public,must-revalidate,max-age=0,post-check=0,pre-check=0'
	
end

---return excle file to browser. User can download it.
--@param #table data out put data
--@param #table header data header
function excel(data, header)
end

---download file
function download(filename, filepath, mimetype)

end