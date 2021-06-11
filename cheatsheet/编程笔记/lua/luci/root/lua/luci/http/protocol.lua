-- Copyright 2008 Freifunk Leipzig / Jo-Philipp Wich <jow@openwrt.org>
-- Licensed to the public under the Apache License 2.0.

-- This class contains several functions useful for http message- and content
-- decoding and to retrive form data from raw http messages.
module("luci.http.protocol", package.seeall)

local ltn12 = require("luci.ltn12")

HTTP_MAX_CONTENT      = 1024*8		-- 8 kB maximum content size

-- the "+" sign to " " - and return the decoded string.
-- + Decode an URL-encoded string - optionally decoding the "+" sign to space.
-- # str: Input string in x-www-urlencoded format
-- # decode_plus: Decode "+" signs to spaces if true (optional)
-- $ The decoded string
function urldecode( str, no_plus ) -- 解码函数(从URL的编码方式 到ASCII的编码方式)

	local function __chrdec( hex )
		return string.char( tonumber( hex, 16 ) )
	end

	if type(str) == "string" then
		if not no_plus then
			str = str:gsub( "+", " " )
		end

		str = str:gsub( "%%([a-fA-F0-9][a-fA-F0-9])", __chrdec )
	end

	return str
end

-- from given url or string. Returns a table with urldecoded values.
-- Simple parameters are stored as string values associated with the parameter
-- name within the table. Parameters with multiple values are stored as array
-- containing the corresponding values.
-- + Extract and split urlencoded data pairs, separated bei either "&" or ";" from given url or string. 
-- + Returns a table with urldecoded values. 
-- + Simple parameters are stored as string values associated with the parameter name within the table. 
-- + Parameters with multiple values are stored as array containing the corresponding values.
-- # url: The url or string which contains x-www-urlencoded form data
-- # tbl: Use the given table for storing values (optional)
-- $ Table containing the urldecoded parameters
function urldecode_params( url, tbl ) -- 返回url中包含的key-value字典

	local params = tbl or { }

	if url:find("?") then
-- ^开头表示匹配开始部分，+匹配1次或者多次，%？转义问号，第三个参数表示捕获第一个匹配字符串。^?表示非问号的部分,.+进行的是最长匹配。
-- Post /cgi-bin/luci HTTP/1.1(application/x-www-form-urlencoded)  
-- Url:http://192.168.1.1/cgi-bin/luci?username=root&password=admin
		url = url:gsub( "^.+%?([^?]+)", "%1" )
	end
-- 查找key、value
	for pair in url:gmatch( "[^&;]+" ) do

		-- find key and value 调用urldecode中pair.match()查找key、val
		local key = urldecode( pair:match("^([^=]+)")     )
		local val = urldecode( pair:match("^[^=]+=(.+)$") )

		-- store 存储值
		-- 调用urldecode中pair.match()查找key、val
		if type(key) == "string" and key:len() > 0 then 
		-- key就是第一句话传进去的id(username)，然后val赋给params[name]
			if type(val) ~= "string" then val = "" end

			if not params[key] then -- 登录页面传进来的值进入这里面
				params[key] = val
			elseif type(params[key]) ~= "table" then
				params[key] = { params[key], val }
			else
				table.insert( params[key], val )
			end
		end
	end

	return params
end

-- + URL-encode given string.
-- # str: String to encode
-- $ String containing the encoded data
function urlencode( str ) -- 编码函数 (从ASCII的编码方式 到URL的编码方式)

	local function __chrenc( chr )
		return string.format(
			"%%%02x", string.byte( chr )
		)
	end

	if type(str) == "string" then
		str = str:gsub(
			"([^a-zA-Z0-9$_%-%.%~])",
			__chrenc
		)
	end

	return str
end

-- separated by "&". Tables are encoded as parameters with multiple values by
-- repeating the parameter name with each value.
-- + Encode each key-value-pair in given table to x-www-urlencoded format, separated by "&". Tables are encoded as parameters with multiple values by repeating the parameter name with each value.
-- # tbl: Table with the values
-- $ String containing encoded values
function urlencode_params( tbl ) -- 将tbl中的字段编码为url中的key-value形式
	local enc = ""

	for k, v in pairs(tbl) do
		if type(v) == "table" then
			for i, v2 in ipairs(v) do
				enc = enc .. ( #enc > 0 and "&" or "" ) ..
					urlencode(k) .. "=" .. urlencode(v2)
			end
		else
			enc = enc .. ( #enc > 0 and "&" or "" ) ..
				urlencode(k) .. "=" .. urlencode(v)
		end
	end

	return enc
end

-- (Internal function)
-- Initialize given parameter and coerce string into table when the parameter
-- already exists.
--[[
1. 如果tbl表中key不存在值，则设置值为""
2. 如果tbl表中key已经有值，则将tbl[key] 值从字符串转换成表，表尾值为""
3. 如果tbl表中key对应一个table, 则在tbl[key] 表尾追加""
--]]
local function __initval( tbl, key )
	if tbl[key] == nil then
		tbl[key] = ""
	elseif type(tbl[key]) == "string" then
		tbl[key] = { tbl[key], "" }
	else
		table.insert( tbl[key], "" )
	end
end

-- (Internal function)
-- Initialize given file parameter.
--[[
1. 如果tbl表中key不存在值，则设置表{ file=filename, fd=fd, name=key, "" }
2. 如果tbl表中key存在值，则在tbl[key] 表尾追加""
--]]
local function __initfileval( tbl, key, filename, fd )
	if tbl[key] == nil then
		tbl[key] = { file=filename, fd=fd, name=key, "" }
	else
		table.insert( tbl[key], "" )
	end
end

-- (Internal function)
-- Append given data to given parameter, either by extending the string value
-- or by appending it to the last string in the parameter's value table.
--[[
1. 如果tbl[key] 指向表，则给表最后一个元素追加chunk
2. 如果tbl[key] 指向字符串，则给字符串追后一个元素追加字符串
--]]
local function __appendval( tbl, key, chunk )
	if type(tbl[key]) == "table" then
		tbl[key][#tbl[key]] = tbl[key][#tbl[key]] .. chunk
	else
		tbl[key] = tbl[key] .. chunk
	end
end

-- (Internal function)
-- Finish the value of given parameter, either by transforming the string value
-- or - in the case of multi value parameters - the last element in the
-- associated values table.
--[[
1. 如果handler存在则对key指向值进行处理
1.1 如果tbl[key] 指向表，则给表最后一个元素进行处理
1.2 如果tbl[key] 指向字符串，则给字符串元素进行处理
--]]
local function __finishval( tbl, key, handler )
	if handler then
		if type(tbl[key]) == "table" then
			tbl[key][#tbl[key]] = handler( tbl[key][#tbl[key]] )
		else
			tbl[key] = handler( tbl[key] )
		end
	end
end


-- Table of our process states
local process_states = { }

-- Extract "magic", the first line of a http message.
-- Extracts the message type ("get", "post" or "response"), the requested uri
-- or the status code if the line descripes a http response.
process_states['magic'] = function( msg, chunk, err )

	if chunk ~= nil then
		-- ignore empty lines before request
		if #chunk == 0 then
			return true, nil
		end

-- GET /favicon.ico HTTP/1.1
-- GET /cgi-bin/luci HTTP/1.1
-- POST /cgi-bin/luci HTTP/1.1
-- GET /cgi-bin/luci/;stok=96e813e780571283b37322e393aa425c HTTP/1.1
-- GET /cgi-bin/luci/;stok=96e813e780571283b37322e393aa425c?status=1&_=0.1799171423246999 HTTP/1.1
		-- Is it a request? -- 通过match解析html的头部
		local method, uri, http_ver = chunk:match("^([A-Z]+) ([^ ]+) HTTP/([01]%.[019])$")

		-- Yup, it is
		if method then

			msg.type           = "request"
			msg.request_method = method:lower()
			msg.request_uri    = uri
			msg.http_version   = tonumber( http_ver )
			msg.headers        = { }

			-- We're done, next state is header parsing
			return true, function( chunk )
				return process_states['headers']( msg, chunk )
			end

		-- Is it a response?
		else
-- HTTP/1.1 404 Not Found
-- HTTP/1.1 403 Forbidden
-- HTTP/1.1 302 Found
-- HTTP/1.1 200 OK
-- HTTP/1.1 200 OK
			local http_ver, code, message = chunk:match("^HTTP/([01]%.[019]) ([0-9]+) ([^\r\n]+)$")

			-- Is a response
			if code then

				msg.type           = "response"
				msg.status_code    = code
				msg.status_message = message
				msg.http_version   = tonumber( http_ver )
				msg.headers        = { }

				-- We're done, next state is header parsing
				return true, function( chunk )
					return process_states['headers']( msg, chunk )
				end
			end
		end
	end

	-- Can't handle it
	return nil, "Invalid HTTP message magic"
end


-- Extract headers from given string.
process_states['headers'] = function( msg, chunk )

	if chunk ~= nil then

		-- Look for a valid header format
		local hdr, val = chunk:match( "^([A-Za-z][A-Za-z0-9%-_]+): +(.+)$" ) -- msg 中符合一定格式的表头

		if type(hdr) == "string" and hdr:len() > 0 and
		   type(val) == "string" and val:len() > 0
		then
			msg.headers[hdr] = val

			-- Valid header line, proceed
			return true, nil

		elseif #chunk == 0 then
			-- Empty line, we won't accept data anymore
			return false, nil
		else
			-- Junk data
			return nil, "Invalid HTTP header received"
		end
	else
		return nil, "Unexpected EOF"
	end
end


-- data line by line with the trailing \r\n stripped of.
function header_source( sock )
	return ltn12.source.simplify( function()

		local chunk, err, part = sock:receive("*l") -- "*line" 读取下一行

		-- Line too long
		if chunk == nil then
			if err ~= "timeout" then
				return nil, part
					and "Line exceeds maximum allowed length"
					or  "Unexpected EOF"
			else
				return nil, err
			end

		-- Line ok
		elseif chunk ~= nil then

			-- Strip trailing CR
			chunk = chunk:gsub("\r$","") -- 去掉换行符

			return chunk, nil
		end
	end )
end

-- Content-Type. Stores all extracted data associated with its parameter name
-- in the params table withing the given message object. Multiple parameter
-- values are stored as tables, ordinary ones as strings.
-- If an optional file callback function is given then it is feeded with the
-- file contents chunk by chunk and only the extracted file name is stored
-- within the params table. The callback function will be called subsequently
-- with three arguments:
--  o Table containing decoded (name, file) and raw (headers) mime header data
--  o String value containing a chunk of the file data
--  o Boolean which indicates wheather the current chunk is the last one (eof)
function mimedecode_message_body( src, msg, filecb ) -- mime结构解码 基本上用于处理cbi|form|arcombine类型页面

	if msg and msg.env.CONTENT_TYPE then
		msg.mime_boundary = msg.env.CONTENT_TYPE:match("^multipart/form%-data; boundary=(.+)$")
	end

	if not msg.mime_boundary then
		return nil, "Invalid Content-Type found"
	end


	local tlen   = 0
	local inhdr  = false
	local field  = nil
	local store  = nil
	local lchunk = nil

	local function parse_headers( chunk, field )
-- Content-Disposition: form-data; name="cbid.system.cfg02e48a._mediaurlbase"
--
-- /luci-static/material
-- 或
-- Content-Disposition: form-data; name="archive"; filename="backup-TAU111-2018-12-04.tar.gz"
		local stat
		repeat
			chunk, stat = chunk:gsub(
				"^([A-Z][A-Za-z0-9%-_]+): +([^\r\n]+)\r\n",
				function(k,v)
					field.headers[k] = v -- k=Content-Disposition v=form-data; name="cbid.system.cfg02e48a._mediaurlbase"
					return ""
				end
			)
		until stat == 0

		chunk, stat = chunk:gsub("^\r\n","") -- chunk 为 value, stat为匹配次数

		-- End of headers -- filename="backup-TAU111-2018-12-04.tar.gz"
		if stat > 0 then  -- name="cbid.system.cfg02e48a._mediaurlbase"
			if field.headers["Content-Disposition"] then
				if field.headers["Content-Disposition"]:match("^form%-data; ") then
					field.name = field.headers["Content-Disposition"]:match('name="(.-)"')
					field.file = field.headers["Content-Disposition"]:match('filename="(.+)"$')
				end
			end

			if not field.headers["Content-Type"] then
				field.headers["Content-Type"] = "text/plain"
			end

			if field.name and field.file and filecb then  -- 指定保存函数(上传文件保存)
				__initval( msg.params, field.name )
				__appendval( msg.params, field.name, field.file )

				store = filecb  -- 回调用于保存到文件
			elseif field.name and field.file then -- 临时保存函数(上传文件保存)
				local nxf = require "nixio"
				local fd = nxf.mkstemp(field.name)
				__initfileval ( msg.params, field.name, field.file, fd )
				if fd then
					store = function(hdr, buf, eof)
						fd:write(buf)
						if (eof) then
							fd:seek(0, "set")
						end
					end
				else
					store = function( hdr, buf, eof )
						__appendval( msg.params, field.name, buf )
					end
				end
			elseif field.name then -- 上传k-v字段保存
				__initval( msg.params, field.name )

				store = function( hdr, buf, eof )
					__appendval( msg.params, field.name, buf ) -- 通过cbi.js 中 cbi_d_update函数在客户端将数据组织过来
				end
			else
				store = nil
			end

			return chunk, true
		end

		return chunk, false
	end

	local function snk( chunk ) -- enclosure function

		tlen = tlen + ( chunk and #chunk or 0 ) -- total length

		if msg.env.CONTENT_LENGTH and tlen > tonumber(msg.env.CONTENT_LENGTH) + 2 then
			return nil, "Message body size exceeds Content-Length"
		end

		if chunk and not lchunk then
			lchunk = "\r\n" .. chunk

		elseif lchunk then
			local data = lchunk .. ( chunk or "" )
			local spos, epos, found

			repeat
				spos, epos = data:find( "\r\n--" .. msg.mime_boundary .. "\r\n", 1, true )

				if not spos then
					spos, epos = data:find( "\r\n--" .. msg.mime_boundary .. "--\r\n", 1, true )
				end


				if spos then
					local predata = data:sub( 1, spos - 1 )

					if inhdr then
						predata, eof = parse_headers( predata, field ) -- 

						if not eof then
							return nil, "Invalid MIME section header"
						elseif not field.name then
							return nil, "Invalid Content-Disposition header"
						end
					end

					if store then
						store( field, predata, true ) -- 将数据保存到指定地方
					end


					field = { headers = { } }
					found = found or true

					data, eof = parse_headers( data:sub( epos + 1, #data ), field )
					inhdr = not eof
				end
			until not spos

			if found then
				-- We found at least some boundary. Save
				-- the unparsed remaining data for the
				-- next chunk.
				lchunk, data = data, nil
			else
				-- There was a complete chunk without a boundary. Parse it as headers or
				-- append it as data, depending on our current state.
				if inhdr then
					lchunk, eof = parse_headers( data, field )
					inhdr = not eof
				else
					-- We're inside data, so append the data. Note that we only append
					-- lchunk, not all of data, since there is a chance that chunk
					-- contains half a boundary. Assuming that each chunk is at least the
					-- boundary in size, this should prevent problems
					store( field, lchunk, false )
					lchunk, chunk = chunk, nil
				end
			end
		end

		return true
	end

	return ltn12.pump.all( src, snk )
end

-- Content-Type. Stores all extracted data associated with its parameter name
-- in the params table withing the given message object. Multiple parameter
-- values are stored as tables, ordinary ones as strings.
-- url 解析了
-- + Decode an urlencoded http message body with application/x-www-urlencoded Content-Type. 
-- + Stores all extracted data associated with its parameter name in the params table within the given message object.
-- + Multiple parameter values are stored as tables, ordinary ones as strings.
-- # src: Ltn12 source function
-- # msg: HTTP message object
-- $ Value indicating successful operation (not nil means "ok")
-- $ String containing the error if unsuccessful
function urldecode_message_body( src, msg )

	local tlen   = 0
	local lchunk = nil

	local function snk( chunk )

		tlen = tlen + ( chunk and #chunk or 0 )

		if msg.env.CONTENT_LENGTH and tlen > tonumber(msg.env.CONTENT_LENGTH) + 2 then
			return nil, "Message body size exceeds Content-Length"
		elseif tlen > HTTP_MAX_CONTENT then
			return nil, "Message body size exceeds maximum allowed length"
		end

		if not lchunk and chunk then
			lchunk = chunk

		elseif lchunk then
			local data = lchunk .. ( chunk or "&" )
			local spos, epos

			repeat
				spos, epos = data:find("^.-[;&]")

				if spos then
					local pair = data:sub( spos, epos - 1 )
					local key  = pair:match("^(.-)=")
					local val  = pair:match("=([^%s]*)%s*$")

					if key and #key > 0 then
						__initval( msg.params, key )
						__appendval( msg.params, key, val )
						__finishval( msg.params, key, urldecode )
					end

					data = data:sub( epos + 1, #data )
				end
			until not spos

			lchunk = data
		end

		return true
	end

	return ltn12.pump.all( src, snk )
end

-- version, message headers and resulting CGI environment variables from the
-- given ltn12 source.
function parse_message_header( src )

	local ok   = true
	local msg  = { }

	local sink = ltn12.sink.simplify(
		function( chunk )
			return process_states['magic']( msg, chunk )
		end
	)

	-- Pump input data...
	while ok do

		-- get data
		ok, err = ltn12.pump.step( src, sink )

		-- error
		if not ok and err then
			return nil, err

		-- eof
		elseif not ok then

			-- Process get parameters
			if ( msg.request_method == "get" or msg.request_method == "post" ) and
			   msg.request_uri:match("?")
			then
				msg.params = urldecode_params( msg.request_uri )
			else
				msg.params = { }
			end

			-- Populate common environment variables
			msg.env = {
				CONTENT_LENGTH    = msg.headers['Content-Length'];
				CONTENT_TYPE      = msg.headers['Content-Type'] or msg.headers['Content-type'];
				REQUEST_METHOD    = msg.request_method:upper();
				REQUEST_URI       = msg.request_uri;
				SCRIPT_NAME       = msg.request_uri:gsub("?.+$","");
				SCRIPT_FILENAME   = "";		-- XXX implement me
				SERVER_PROTOCOL   = "HTTP/" .. string.format("%.1f", msg.http_version);
				QUERY_STRING      = msg.request_uri:match("?")
					and msg.request_uri:gsub("^.+?","") or ""
			}

			-- Populate HTTP_* environment variables
			for i, hdr in ipairs( {
				'Accept',
				'Accept-Charset',
				'Accept-Encoding',
				'Accept-Language',
				'Connection',
				'Cookie',
				'Host',
				'Referer',
				'User-Agent',
			} ) do
				local var = 'HTTP_' .. hdr:upper():gsub("%-","_")
				local val = msg.headers[hdr]

				msg.env[var] = val
			end
		end
	end

	return msg
end

-- This function will examine the Content-Type within the given message object
-- to select the appropriate content decoder.
-- Currently the application/x-www-urlencoded and application/form-data
-- mime types are supported. If the encountered content encoding can't be
-- handled then the whole message body will be stored unaltered as "content"
-- property within the given message object.
-- + Try to extract and decode a http message body from the given ltn12 source.
-- + This function will examine the Content-Type within the given message object to select the appropriate content decoder. 
-- + Currently the application/x-www-urlencoded and application/form-data mime types are supported.
-- + If the encountered content encoding can't be handled then the whole message body will be stored unaltered as "content" property within the given message object.
-- # src: Ltn12 source function
-- # msg: HTTP message object
-- # filecb: File data callback (optional, see mimedecode_message_body())
-- $ Value indicating successful operation (not nil means "ok")
-- $ String containing the error if unsuccessful
--[[
根据request_method和content_type对接收到的数据的body部分进行处理
1. request_method == "POST" 同时 CONTENT_TYPE ~= "multipart/form%-data"
	mimedecode_message_body
2. request_method == "POST" 同时 CONTENT_TYPE ~= "application/x%-www%-form%-urlencoded"
	urldecode_message_body
3. 其他类型的body
    
]] -- filecb 用于处理上传上来的数据
function parse_message_body( src, msg, filecb )
	-- Is it multipart/mime ?  原生 <form> 表单  上传
	--  (luci\view\cbi\header.htm)  (luci\view\cbi\simpleform.htm) smtp.lua
	if msg.env.REQUEST_METHOD == "POST" and msg.env.CONTENT_TYPE and
	   msg.env.CONTENT_TYPE:match("^multipart/form%-data") -- % 在模式匹配中起到字符转义作用
	then
		return mimedecode_message_body( src, msg, filecb )

	-- Is it application/x-www-form-urlencoded ?  下载
	elseif msg.env.REQUEST_METHOD == "POST" and msg.env.CONTENT_TYPE and -- % 在模式匹配中起到字符转义作用
	       msg.env.CONTENT_TYPE:match("^application/x%-www%-form%-urlencoded")
	then
		return urldecode_message_body( src, msg, filecb )


	-- Unhandled encoding
	-- If a file callback is given then feed it chunk by chunk, else
	-- store whole buffer in message.content
	-- 基本上用于处理 template 类型页面
	else

		local sink

		-- If we have a file callback then feed it
		if type(filecb) == "function" then
			local meta = {
				name = "raw",
				encoding = msg.env.CONTENT_TYPE
			}
			sink = function( chunk )
				if chunk then
					return filecb(meta, chunk, false)
				else
					return filecb(meta, nil, true)
				end
			end
		-- ... else append to .content
		else
			msg.content = ""
			msg.content_length = 0

			sink = function( chunk )
				if chunk then
					if ( msg.content_length + #chunk ) <= HTTP_MAX_CONTENT then
						msg.content        = msg.content        .. chunk
						msg.content_length = msg.content_length + #chunk
						return true
					else
						return nil, "POST data exceeds maximum allowed length"
					end
				end
				return true
			end
		end

		-- Pump data...
		while true do
			local ok, err = ltn12.pump.step( src, sink )

			if not ok and err then
				return nil, err
			elseif not ok then -- eof
				return true
			end
		end

		return true
	end
end
-- 消息码 与 消息内容对应表
statusmsg = {
	[200] = "OK",
	[206] = "Partial Content",
	[301] = "Moved Permanently",
	[302] = "Found",
	[304] = "Not Modified",
	[400] = "Bad Request",
	[403] = "Forbidden",
	[404] = "Not Found",
	[405] = "Method Not Allowed",
	[408] = "Request Time-out",
	[411] = "Length Required",
	[412] = "Precondition Failed",
	[416] = "Requested range not satisfiable",
	[500] = "Internal Server Error",
	[503] = "Server Unavailable",
}
