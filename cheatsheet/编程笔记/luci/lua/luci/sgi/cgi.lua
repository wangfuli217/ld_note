-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Licensed to the public under the Apache License 2.0.

exectime = os.clock()
module("luci.sgi.cgi", package.seeall)
local ltn12 = require("luci.ltn12")
require("nixio.util")
require("luci.http")
require("luci.sys")
require("luci.dispatcher")

-- Limited source to avoid endless blocking
local function limitsource(handle, limit) -- 返回一个迭代器，内容为页面数据
	limit = limit or 0
	local BLOCKSIZE = ltn12.BLOCKSIZE

	return function()
		if limit < 1 then
			handle:close()
			return nil
		else
			local read = (limit > BLOCKSIZE) and BLOCKSIZE or limit
			limit = limit - read

			local chunk = handle:read(read)
			if not chunk then handle:close() end
			return chunk
		end
	end
end

function run()
	local r = luci.http.Request(
		luci.sys.getenv(),  -- 有参数情况下获得具体的值，没有的情况下，获得所有的值;           返回环境变量tables
		limitsource(io.stdin, tonumber(luci.sys.getenv("CONTENT_LENGTH"))), -- 读取post数据
        -- CONTENT_LENGTH  返回基于流的迭代函数 输入
		ltn12.sink.file(io.stderr) -- 返回一个输出函数                                         返回基于流的迭代函数 输出
	)
	-- main是消费者，luci.dispatcher.httpdispatch是生产者，消费数据就是输出数据，生产数据却复杂多了
	local x = coroutine.create(luci.dispatcher.httpdispatch) 
	local hcache = ""
	local active = true
	
	while coroutine.status(x) ~= "dead" do
		local res, id, data1, data2 = coroutine.resume(x, r) -- 将r传递给luci.dispatcher.httpdispatch,执行
 -- res 协程状态， 
		if not res then
			print("Status: 500 Internal Server Error")
			print("Content-Type: text/plain\n")
			print(id)
			break;
		end
 -- id 返回数据类型
 -- data1 返回数据内容
 -- data2 返回数据内容
		if active then
			if id == 1 then -- http res line -> luci.http.status(code, message)                    == 在controller部分被调用
				io.write("Status: " .. tostring(data1) .. " " .. data2 .. "\r\n") -- data1-code data2-message
			elseif id == 2 then --           -> luci.http.header(key, value)                       == 在控制和template中
				hcache = hcache .. data1 .. ": " .. data2 .. "\r\n" -- 准备header -- data1-key  data2-value
			elseif id == 3 then --           -> luci.http.write(key, value) 或者 luci.http.close() == 在控制和template中
				io.write(hcache)     -- 写header blank  -- hcache-(key:value)+
				io.write("\r\n")     -- 默认到stdout
			elseif id == 4 then --           -> luci.http.write(key, value)                        == 在控制和template中
				io.write(tostring(data1 or "")) -- 写body   data1-content
			elseif id == 5 then --           -> luci.http.close()                                  == 流程性httpdispatch最后一步
				io.flush()
				io.close()                   -- EOF 根据状态操作值
				active = false
			elseif id == 6 then --           -> luci.http.splice 暂时没用
				data1:copyz(nixio.stdout, data2)
				data1:close()
			end
		end
	end
end
