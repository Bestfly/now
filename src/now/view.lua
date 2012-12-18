local base = require 'now.base'
local tpl = require 'now.tpl'
local xml = require 'now.util.xml'
local excel = require 'now.util.excel'
local ngx = ngx

---view
module(...)

---return json string to browser
--@param #table data out put data
function json(data)
	ngx.header['Content-Type'] = 'text/html;charset=utf-8'
	ngx.header['Expires'] = '0'
	ngx.header['Cache-Control'] = 'public,must-revalidate,max-age=0,post-check=0,pre-check=0'
	ngx.print(base.json_encode(data))
end

---return jsonp string to browser
--@param #table data out put data
--@param #string callback javascript callback function name
function jsonp(data, callback)
	ngx.header['Content-Type'] = 'text/html;charset=utf-8'
	ngx.header['Expires'] = '0'
	ngx.header['Cache-Control'] = 'public,must-revalidate,max-age=0,post-check=0,pre-check=0'
	ngx.print(callback..'('..base.json_encode(data)..')')
end

---return html string to browser
--@param #table data out put data
--@param #string tbl template module name
--@param #string key key in the template module
function tpl(data, tpl, key)
	ngx.header['Content-Type'] = 'text/html;charset=utf-8'
	ngx.header['Expires'] = '0'
	ngx.header['Cache-Control'] = 'public,must-revalidate,max-age=0,post-check=0,pre-check=0'
	ngx.print(tpl.tpl(tpl, key, data))
end

---return xml string to browser
--@param #table data out put data
function xml(data)
	ngx.header['Content-Type'] = 'text/xml;charset=utf-8'
	ngx.header['Expires'] = '0'
	ngx.header['Cache-Control'] = 'public,must-revalidate,max-age=0,post-check=0,pre-check=0'
	
end

---return excle file to browser. User can download it.
--@param #table data out put data
--@param #table header data header
function excel(data, header)
end

---download file
function download(filename, filepath, mimetype)

end