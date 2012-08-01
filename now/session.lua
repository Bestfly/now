---session处理
module("now.session", package.seeall)

local mt = { __index = now.session}

function make_session()
end

function get_session()
end

function get(key)
end

function set(key, val)
end

function del(key)
end