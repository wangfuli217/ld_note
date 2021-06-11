-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Licensed to the public under the Apache License 2.0.

local ltn12 = require "luci.ltn12"
local protocol = require "luci.http.protocol"
local util  = require "luci.util"
local string = require "string"
local coroutine = require "coroutine"
local table = require "table"

local ipairs, pairs, next, type, tostring, error =
	ipairs, pairs, next, type, tostring, error

module "luci.http"

context = util.threadlocal()

Request = util.class()
function Request.__init__(self, env, sourcein, sinkerr)
	self.input = sourcein   -- 页面内容输入
	self.error = sinkerr    -- 处理错误输出


	-- File handler nil by default to let .content() work
	self.filehandler = nil

	-- HTTP-Message table
	self.message = {
		env = env,     -- 所有环境变量
		headers = {},  -- 头表
		params = protocol.urldecode_params(env.QUERY_STRING or ""), -- 将最初的"Username"传到了params这里，然后调用http/protocol.lua文件中的
	}

	self.parsed_input = false -- 返回self的值
end

function Request.formvalue(self, name, noparse)
	if not noparse and not self.parsed_input then
		self:_parse_input()
	end

	if name then
		return self.message.params[name]
	else
		return self.message.params
	end
end

function Request.formvaluetable(self, prefix)
	local vals = {}
	prefix = prefix and prefix .. "." or "."

	if not self.parsed_input then
		self:_parse_input()
	end

	local void = self.message.params[nil]
	for k, v in pairs(self.message.params) do
		if k:find(prefix, 1, true) == 1 then
			vals[k:sub(#prefix + 1)] = tostring(v)
		end
	end

	return vals
end

function Request.content(self)
	if not self.parsed_input then
		self:_parse_input()
	end

	return self.message.content, self.message.content_length
end

function Request.getcookie(self, name)
  local c = string.gsub(";" .. (self:getenv("HTTP_COOKIE") or "") .. ";", "%s*;%s*", ";")
  local p = ";" .. name .. "=(.-);"
  local i, j, value = c:find(p)
  return value and urldecode(value)
end

function Request.getenv(self, name)
	if name then
		return self.message.env[name]
	else
		return self.message.env
	end
end

function Request.setfilehandler(self, callback)
	self.filehandler = callback

	-- If input has already been parsed then any files are either in temporary files
	-- or are in self.message.params[key]
	if self.parsed_input then
		for param, value in pairs(self.message.params) do
		repeat
			-- We're only interested in files
			if (not value["file"]) then break end
			-- If we were able to write to temporary file
			if (value["fd"]) then 
				fd = value["fd"]
				local eof = false
				repeat	
					filedata = fd:read(1024)
					if (filedata:len() < 1024) then
						eof = true
					end
					callback({ name=value["name"], file=value["file"] }, filedata, eof)
				until (eof)
				fd:close()
				value["fd"] = nil
			-- We had to read into memory
			else
				-- There should only be one numbered value in table - the data
				for k, v in ipairs(value) do
					callback({ name=value["name"], file=value["file"] }, v, true)
				end
			end
		until true
		end
	end
end

function Request._parse_input(self)
	protocol.parse_message_body(
		 self.input,
		 self.message,
		 self.filehandler
	)
	self.parsed_input = true
end

function close()  -- 头部分写入 -- 执行httpdispatch(request, prefix)中luci.http.close()时，
	if not context.eoh then
		context.eoh = true
		coroutine.yield(3)
	end

	if not context.closed then
		context.closed = true
		coroutine.yield(5) -- BODY写入结束，刷缓冲区
	end
end

function content()
	return context.request:content()
end

-- 用来获取我们的post过去表单的值的，
-- 假设你配置页面是一个帐号和密码，然后你需要在点击按键"保存并应用"的时候启动我们的应用程序,那么你只要检测该按键的值是否传递过去了，
-- 如果传递过去了则是用户提交后页面，如果没有这个值，那么只是用户第一次进入这个页面而已.
function formvalue(name, noparse)
	return context.request:formvalue(name, noparse) -- 然后调用Request.formvalue(self, name, noparse)
end

function formvaluetable(prefix)
	return context.request:formvaluetable(prefix)
end

function getcookie(name)
	return context.request:getcookie(name)
end

-- or the environment table itself.
function getenv(name)
	return context.request:getenv(name)
end

function setfilehandler(callback)
	return context.request:setfilehandler(callback)
end

-- 1.执行dispatch()函数luci.http.header('SetCookie','sysauth=' .. Sid ..';path=',build_url())时调用此函数;
-- 2. 调用_cbi()函数中http.header(“X-CBI-State”, state or 0)时
function header(key, value) 
	if not context.headers then
		context.headers = {}
	end
	context.headers[key:lower()] = value
	coroutine.yield(2, key, value) --返回header数据
end

function prepare_content(mime)
	if not context.headers or not context.headers["content-type"] then
		if mime == "application/xhtml+xml" then
			if not getenv("HTTP_ACCEPT") or
			  not getenv("HTTP_ACCEPT"):find("application/xhtml+xml", nil, true) then
				mime = "text/html; charset=UTF-8"
			end
			header("Vary", "Accept")
		end
		header("Content-Type", mime)
	end
end

function source()
	return context.request.input
end
-- 1.dispatcher.lua中执行error404(message)函数，然后执行此函数;
-- 2.error500(message)函数;
-- 3.还有dispatch()中luci.http.status(403,”Forbidden”);
function status(code, message) -- 返回状态码
	code = code or 200
	message = message or "OK"
	context.status = code
	coroutine.yield(1, code, message)
end

-- This function is as a valid LTN12 sink.
-- If the content chunk is nil this function will automatically invoke close.
-- 1.在error404()中执行luci.http.write(message)时，
-- 2.在error500(message)中luci.http.write(message)时，
function write(content, src_err)
	if not content then
		if src_err then
			error(src_err)
		else
			close()
		end
		return true
	elseif #content == 0 then
		return true
	else
		if not context.eoh then
			if not context.status then
				status()
			end
			if not context.headers or not context.headers["content-type"] then
				header("Content-Type", "text/html; charset=utf-8")
			end
			if not context.headers["cache-control"] then
				header("Cache-Control", "no-cache")
				header("Expires", "0")
			end


			context.eoh = true
			coroutine.yield(3) -- 头部分写入
		end
		coroutine.yield(4, content) -- 数据内容部分
		return true
	end
end

-- httpclient文件夹下的receive.lua包含nixio.splice()
function splice(fd, size)
	coroutine.yield(6, fd, size) -- 待分析
end

function redirect(url)
	if url == "" then url = "/" end
	status(302, "Found")
	header("Location", url)
	close()
end

function build_querystring(q)
	local s = { "?" }

	for k, v in pairs(q) do
		if #s > 1 then s[#s+1] = "&" end

		s[#s+1] = urldecode(k)
		s[#s+1] = "="
		s[#s+1] = urldecode(v)
	end

	return table.concat(s, "")
end

urldecode = protocol.urldecode

urlencode = protocol.urlencode

function write_json(x)
	util.serialize_json(x, write)
end
