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
-- �����ӱ�׼�����ж�ȡ�����ݣ����������ر�������������nil
local function limitsource(handle, limit) -- ����һ��������������Ϊҳ������
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

-- ��ȫ�Ļ����д򿪿�ʼҳ��(��¼ҳ��) ���� run �У�����Ҫ�Ĺ��ܻ����� dispatch.lua ����ɡ�
function run()
	local r = luci.http.Request(
		luci.sys.getenv(),  -- ����һЩ�̶���ʽ������(��PATH_INFO)��luci  ���ػ�������tables
		limitsource(io.stdin, tonumber(luci.sys.getenv("CONTENT_LENGTH"))), -- ��ȡpost����
		-- һЩ�ǹ̶���ʽ�����ݣ�post-data�����ɸ�����ͨ��һ��w_pipeд��luci��stdin
        -- CONTENT_LENGTH  ���ػ������ĵ������� ����
		ltn12.sink.file(io.stderr) -- ����һ���������   ���ػ������ĵ������� ���
		-- Creates a sink that sends data to a file
	) -- <ҳ�����벿��>
	
	-- main�������ߣ�luci.dispatcher.httpdispatch�������ߣ��������ݾ���������ݣ���������ȴ���Ӷ���
	local x = coroutine.create(luci.dispatcher.httpdispatch) 
	local hcache = ""
	local active = true
	
	while coroutine.status(x) ~= "dead" do -- <ҳ���������>
		local res, id, data1, data2 = coroutine.resume(x, r) -- ��r���ݸ�luci.dispatcher.httpdispatch,ִ��
 -- res Э��״̬�� 
		if not res then
			print("Status: 500 Internal Server Error")
			print("Content-Type: text/plain\n")
			print(id)
			break;
		end
		
-- luci�ķ���������д��stdout�ϣ��ɸ�����ͨ��һ��r_pipe��ȡ��

 -- id ������������
 -- data1 ������������
 -- data2 ������������
		if active then
			if id == 1 then -- http res line -> luci.http.status(code, message)                    == ��controller���ֱ�����
				io.write("Status: " .. tostring(data1) .. " " .. data2 .. "\r\n") -- data1-code data2-message
			elseif id == 2 then --           -> luci.http.header(key, value)                       == �ڿ��ƺ�template��
				hcache = hcache .. data1 .. ": " .. data2 .. "\r\n" -- ׼��header -- data1-key  data2-value
			elseif id == 3 then --           -> luci.http.write(key, value) ���� luci.http.close() == �ڿ��ƺ�template��
				io.write(hcache)     -- дheader blank  -- hcache-(key:value)+
				io.write("\r\n")     -- Ĭ�ϵ�stdout
			elseif id == 4 then --           -> luci.http.write(key, value)                        == �ڿ��ƺ�template��
				io.write(tostring(data1 or "")) -- дbody   data1-content
			elseif id == 5 then --           -> luci.http.close()                                  == ������httpdispatch���һ��
				io.flush()
				io.close()                   -- EOF ����״̬����ֵ
				active = false
			elseif id == 6 then --           -> luci.http.splice ��ʱû��
				data1:copyz(nixio.stdout, data2)
				data1:close()
			end
		end
	end
end
