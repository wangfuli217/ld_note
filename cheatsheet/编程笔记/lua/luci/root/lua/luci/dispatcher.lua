-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Copyright 2008-2015 Jo-Philipp Wich <jow@openwrt.org>
-- Licensed to the public under the Apache License 2.0.

local fs = require "nixio.fs"
local sys = require "luci.sys"
local util = require "luci.util"
local http = require "luci.http"
local nixio = require "nixio", require "nixio.util"

module("luci.dispatcher", package.seeall)
context = util.threadlocal()
uci = require "luci.model.uci"
i18n = require "luci.i18n"
_M.fs = fs

-- Index table
local index = nil

-- Fastindex
local fi

-- dsp.build_url("/admin/system/wifitest")
-- dsp.build_url("admin", "testnet", "control") 
-- + Build the URL relative to the server webroot from given virtual path.
-- # ...: Virtual path
-- $ Relative URL
function build_url(...)
	local path = {...}
	local url = { http.getenv("SCRIPT_NAME") or "" }

	local p
	for _, p in ipairs(path) do
		if p:match("^[a-zA-Z0-9_%-%.%%/,;]+$") then
			url[#url+1] = "/"
			url[#url+1] = p
		end
	end

	if #path == 0 then
		url[#url+1] = "/"
	end

	return table.concat(url, "")
end

-- + Check whether a dispatch node shall be visible
-- # node: Dispatch node
-- $ Boolean indicating whether the node should be visible
function node_visible(node)
   if node then
	  return not (
		 (not node.title or #node.title == 0) or
		 (not node.target or node.hidden == true) or
		 (type(node.target) == "table" and node.target.type == "firstchild" and
		  (type(node.nodes) ~= "table" or not next(node.nodes)))
	  )
   end
   return false
end


-- + Return a sorted table of visible childs within a given node
-- # node: Dispatch node
-- $ Ordered table of child node names
function node_childs(node)
	local rv = { }
	if node then
		local k, v
		for k, v in util.spairs(node.nodes,
			function(a, b)
				return (node.nodes[a].order or 100)
				     < (node.nodes[b].order or 100)
			end)
		do
			if node_visible(v) then
				rv[#rv+1] = k
			end
		end
	end
	return rv
end

-- + Send a 404 error code and render the "error404" template if available.
-- # message: Custom error message (optional)
-- $ false
function error404(message)
	http.status(404, "Not Found")
	message = message or "Not Found"

	require("luci.template")
	if not util.copcall(luci.template.render, "error404") then
		http.prepare_content("text/plain")
		http.write(message) -- ����404����
	end
	return false
end

-- + Send a 500 error code and render the "error500" template if available.
-- # message: Custom error message (optional)#
-- $ false
function error500(message)
	util.perror(message)
	if not context.template_header_sent then
		http.status(500, "Internal Server Error")
		http.prepare_content("text/plain")
		http.write(message) -- ����500����
	else
		require("luci.template")
		if not util.copcall(luci.template.render, "error500", {message=message}) then
			http.prepare_content("text/plain")
			http.write(message)  -- ����500����
		end
	end
	return false
end

-- ����http.Request��http.context.request; ����context.request����ΪPATH_INFO���ݣ�
-- Ȼ����dispath���� context.request����
-- + Dispatch an HTTP request.
-- # request: LuCI HTTP Request object
-- #
-- $ 
-- httpdispatch��һ����������coroutine.resume(x,r)������������r�� prefixΪ�ա�
-- httpdispatch����Ҫ�����Ǵӻ�������PATH_INFO��ȡ����·��
-- ���ִ�"http://192.168.1.1/cgi-bin/luci/;stok=e10fa5c70fbb55d478eb8b8a2eaabc6f/admin/network/firewall/"
-- ��������ַ��������ɵ����ַ������table r{}�У�����ٵ���dispatch()���������������󣬹ر�http���ӡ�
function httpdispatch(request, prefix)
	http.context.request = request -- ��ȡ��http.lua�л��������Ϣ

	local r = {}
	context.request = r -- ������context �е�r�ֶε�����

   -- /;stok=8c7b898582084115e279bbce1e50ccb2/admin/status/syslog
	local pathinfo = http.urldecode(request:getenv("PATH_INFO") or "", true) -- ���ػ�������PATH_INFO

	if prefix then
		for _, node in ipairs(prefix) do
			r[#r+1] = node
		end
	end

	for node in pathinfo:gmatch("[^/]+") do  -- ģʽƥ��/ ��ͷ���ַ��� 
		r[#r+1] = node
	end
--  {1 = 'admin'    2 = 'status'    3 = 'syslog'}
	
    -- context.request Ϊֻ����adminԪ�ص�����
    -- dispatch�������������LuCI�еĺ���
    -- ÿ��dispatch()�����path_info�����������ÿһ�㶼���ҵ��Ľڵ���Ϣ����һ������track�У�
    -- ������ʹ���ϲ�node����Ϣ��Ӱ���²�node�����²�node����Ϣ�ֻḲ���ϲ�node��
    -- ����{/admin/system}������auto=false��target=aa��������admin��sysauthֵ�������Ŵ��������ӽڵ㣬Ҳ������admin�µĽڵ㶼��Ҫ��֤��
	local stat, err = util.coxpcall(function()
		dispatch(context.request) -- ��ʱcontext.request��������PATH_INFO��Ϣ
	end, error500)

	http.close()

	--context._disable_memtrace()
end

-- target����node�ڵ㣬�ýڵ���post��ʱ��, ����ȷ��client��post�ύֵ�Ƿ��Ԥ��ֵһ��
-- �������Ԥ��ֵΪtrue��ֱ�ӷ���
local function require_post_security(target)
	if type(target) == "table" then
		if type(target.post) == "table" then
			local param_name, required_val, request_val

			for param_name, required_val in pairs(target.post) do
				request_val = http.formvalue(param_name)

				if (type(required_val) == "string" and
				    request_val ~= required_val) or
				   (required_val == true and
				    (request_val == nil or request_val == ""))
				then
					return false
				end
			end

			return true
		end

		return (target.post == true)
	end

	return false
end

-- �ж����Ӱ�ȫ��
function test_post_security()
	if http.getenv("REQUEST_METHOD") ~= "POST" then
		http.status(405, "Method Not Allowed")
		http.header("Allow", "POST")
		return false
	end

	if http.formvalue("token") ~= context.authtoken then
		http.status(403, "Forbidden")
		luci.template.render("csrftoken")
		return false
	end

	return true
end

-- ubus call session list
-- ubus call session get  '{"ubus_rpc_session": "72c9303cc3dce366b30aaab84d500a4e" }'

-- "ubus_rpc_session": "72c9303cc3dce366b30aaab84d500a4e",
--        "timeout": 3600,
--        "expires": 3596,
--        "acls": {
--
--        },
--        "data": {
--                "section": "7fc50e8719c061ec8dcd3eeebc0eb131",
--                "token": "0c17d3b7316b368dbc3b691ab087043c",
--                "user": "root"
-- }
local function session_retrieve(sid, allowed_users)
	local sdat = util.ubus("session", "get", { ubus_rpc_session = sid })

	if type(sdat) == "table" and
	   type(sdat.values) == "table" and
	   type(sdat.values.token) == "string" and
	   (not allowed_users or
	    util.contains(allowed_users, sdat.values.username))
	then
		return sid, sdat.values
	end

	return nil, nil
end

local function session_setup(user, pass, allowed_users)
	if util.contains(allowed_users, user) then
		local login = util.ubus("session", "login", {
			username = user,
			password = pass,
			timeout  = tonumber(luci.config.sauth.sessiontime)
		})

		if type(login) == "table" and
		   type(login.ubus_rpc_session) == "string"
		then
			util.ubus("session", "set", { -- ����ubus call session set ����
				ubus_rpc_session = login.ubus_rpc_session,
				values = { token = sys.uniqueid(16) }
			})

			return session_retrieve(login.ubus_rpc_session)
		end
	end

	return nil, nil
end

-- + Dispatches a LuCI virtual path.
-- # request: Virtual path
-- $ 
function dispatch(request)
	--context._disable_memtrace = require "luci.debug".trap_memtrace("l")
	local ctx = context -- util.threadlocal()
	ctx.path = request -- �����е�·��  1 = 'admin'    2 = 'status'    3 = 'syslog'

	local conf = require "luci.config" -- uci����ģ��; ��ȡ�����ļ�����ȡluci������Ϣ
	assert(conf.main,                  -- mainΪluci��������
		"/etc/config/luci seems to be corrupt, unable to find section 'main'")
		
-- A. �������������Ϣ
	local i18n = require "luci.i18n"
	local lang = conf.main.lang or "auto"  -- /etc/config/luci/{lang} 
	if lang == "auto" then                                       -- html lang="zh-cn"
		local aclang = http.getenv("HTTP_ACCEPT_LANGUAGE") or "" -- HTTP_ACCEPT_LANGUAGE ����
		for lpat in aclang:gmatch("[%w-]+") do
			lpat = lpat and lpat:gsub("-", "_") -- ��ƽ̨�����е��л��߻����»���
			if conf.languages[lpat] then -- ƽָ̨��������
				lang = lpat
				break
			end
		end
	end
	if lang == "auto" then
		lang = i18n.default -- Ĭ���趨���ԣ���i18n�ļ��У�default = "en"
	end
	i18n.setlanguage(lang) -- ��������
--  B.����node-tree�ڵ����ṹ  
	local c = ctx.tree
	local stat
	if not c then
		c = createtree()     -- �˺�����controller�µ�index����������node-tree�ṹ�ļ�
	end

	local track = {} -- ÿһ����ҵ���node��Ϣ�������track()��
	local args = {}
	ctx.args = args
	ctx.requestargs = ctx.requestargs or args -- �������
	local n
	local preq = {}
	local freq = {}
--��������·���õ�nodetree��·����Ϣ
	for i, s in ipairs(request) do
		preq[#preq+1] = s
		freq[#freq+1] = s
		c = c.nodes[s]
		n = i
		if not c then
			break
		end
							  -- ����·��������node����
		util.update(track, c) -- ��node�ڵ������ȫ�����ø�track, ���ڵ���Ծ�����sysauth����

		if c.leaf then -- Ҷ�ӽڵ��ʱ��
			break
		end
	end

	if c and c.leaf then
		for j=n+1, #request do
			args[#args+1] = request[j] -- ��ӷ���Ŀ¼
			freq[#freq+1] = request[j] -- ��ӷ���Ŀ¼
		end
	end

	ctx.requestpath = ctx.requestpath or freq
	ctx.path = preq

	if track.i18n then
		i18n.loadc(track.i18n)
	end
	-- track����Ҫ�ҵ��ˣ���ǰURL��Ҫ������Ǹ���������
	
-- C.��Ҫ��ʾ�Ĳ���
	-- Init template engine
	if (c and c.index) or not track.notemplate then
		local tpl = require("luci.template")
		local media = track.mediaurlbase or luci.config.main.mediaurlbase
		-- media : /luci-static/material
		if not pcall(tpl.Template, "themes/%s/header" % fs.basename(media)) then
			media = nil
			for name, theme in pairs(luci.config.themes) do
				if name:sub(1,1) ~= "." and pcall(tpl.Template,
				 "themes/%s/header" % fs.basename(theme)) then
					media = theme
				end
			end
			assert(media, "No valid theme found")
		end

		local function _ifattr(cond, key, val)
			if cond then
				local env = getfenv(3)
				local scope = (type(env.self) == "table") and env.self
				if type(val) == "table" then
					if not next(val) then
						return ''
					else
						val = util.serialize_json(val)
					end
				end
				return string.format(
					' %s="%s"', tostring(key),
					util.pcdata(tostring( val
					 or (type(env[key]) ~= "function" and env[key])
					 or (scope and type(scope[key]) ~= "function" and scope[key])
					 or "" ))
				)
			else
				return ''
			end
		end
-- ��ʼ��ģ��
-- �������¼��ҳ�����ת��/,����/admin,
-- �����Ҫ��֤����ô�������ᵯ��htmlauth.htmҳ�棬Ȼ��
-- ���û����֤�ɹ����������ҳ�棬
-- ����ɹ��ˣ���ô������ת/,Ȼ��admin/
-- ��ʱpost������Ϣ��Ȼ��alias��entry.order��С���Ǹ�node��
-- ����Ȼ��/admin/status.lua,Ȼ��status���node��alias��overview���node��
-- ����Ҫ�Ļ�����diapatcher.lua�ļ��е�dispatch()����֤���֡�
		tpl.context.viewns = setmetatable({ -- ���� ���巽��(����template������ͬ�ķ���)
		   write       = http.write;
		   include     = function(name) tpl.Template(name):render(getfenv(2)) end;
		   translate   = i18n.translate;
		   translatef  = i18n.translatef;
		   export      = function(k, v) if tpl.context.viewns[k] == nil then tpl.context.viewns[k] = v end end;
		   striptags   = util.striptags;
		   pcdata      = util.pcdata;
		   media       = media;
		   theme       = fs.basename(media);
		   resource    = luci.config.main.resourcebase;
		   ifattr      = function(...) return _ifattr(...) end;
		   attr        = function(...) return _ifattr(true, ...) end;
		   url         = build_url;
		}, {__index=function(table, key)  -- Ԫ��__index��չ����(��ͬ��template���в�ͬ������)
			if key == "controller" then
				return build_url()
			elseif key == "REQUEST_URI" then
				return build_url(unpack(ctx.requestpath))
			elseif key == "token" then
				return ctx.authtoken
			else
				return rawget(table, key) or _G[key]
			end
		end})
	end

	track.dependent = (track.dependent ~= false)
	assert(not track.dependent or not track.auto,
		"Access Violation\nThe page at '" .. table.concat(request, "/") .. "/' " ..
		"has no parent node so the access to this location has been denied.\n" ..
		"This is a software bug, please report this message at " ..
		"https://github.com/openwrt/luci/issues"
	)
-- D.��֤ �˲��ֺ�192.168.100.1���ڽϴ����
	if track.sysauth then     -- �Ự���� template ��֤
		local authen = track.sysauth_authenticator -- admin/index.lua:18: page.sysauth_authenticator = "htmlauth"
		local _, sid, sdat, default_user, allowed_users

		if type(authen) == "string" and authen ~= "htmlauth" then
			error500("Unsupported authenticator %q configured" % authen)
			return
		end

		if type(track.sysauth) == "table" then -- page.sysauth = "root" �� ���Ϊ��������û���¼
			default_user, allowed_users = nil, track.sysauth
		else
			default_user, allowed_users = track.sysauth, { track.sysauth } -- ����sysauthΪ�ַ��������ж�Ϊroot
		end

		if type(authen) == "function" then -- page.sysauth_authenticator = "htmlauth"
			_, sid = authen(sys.user.checkpasswd, allowed_users)
		else
			sid = http.getcookie("sysauth") -- ����Ϊ�ַ��������ִ�д�����
		end
        -- 
		sid, sdat = session_retrieve(sid, allowed_users) -- ��ubus�л�ȡ�����û���sid,����������������֤����

		if not (sid and sdat) and authen == "htmlauth" then
			local user = http.getenv("HTTP_AUTH_USER") -- ��ȡ�û��� ��������
			local pass = http.getenv("HTTP_AUTH_PASS") -- ��ȡ����   ��������

			if user == nil and pass == nil then
				user = http.formvalue("luci_username") -- ��ȡ�û��� URL���� input�е�luci_username
				pass = http.formvalue("luci_password") -- ��ȡ����   URL���� input�е�luci_password
			end

			sid, sdat = session_setup(user, pass, allowed_users) -- ��Ȼsid��sdat�����ڣ�����authenȷʵ����htmlauth

			if not sid then
				local tmpl = require "luci.template"

				context.path = {}

				http.status(403, "Forbidden")
				tmpl.render(track.sysauth_template or "sysauth", { -- ��ת����֤ҳ��
					duser = default_user,  -- duser����
					fuser = user           -- fuser����
				})

				return
			end

			http.header("Set-Cookie", 'sysauth=%s; path=%s' %{ sid, build_url() })
			http.redirect(build_url(unpack(ctx.requestpath)))
		end

		if not sid or not sdat then
			http.status(403, "Forbidden")
			return
		end

		ctx.authsession = sid
		ctx.authtoken = sdat.token
		ctx.authuser = sdat.username
	end
-- �ȶ������Ӧ����Ƶ�һ���ԣ���ҪΪpost�ؼ��֣�table��boolean
	if c and require_post_security(c.target) then
-- �ȶ������Ӧ��Э���һ����
		if not test_post_security(c) then
			return
		end
	end

	if track.setgroup then
		sys.process.setgroup(track.setgroup)
	end

	if track.setuser then
		sys.process.setuser(track.setuser)
	end

	local target = nil
	-- ����c����entry������node��ڵ�
	if c then -- ����index.lua���жϣ�target��firstchild()����
		if type(c.target) == "function" then -- ����ڵ��targetָ��������Ŀ¼�ڵ�
			target = c.target
		elseif type(c.target) == "table" then -- ��ʵ�ڵ��targetָ��table����dhcp_static dhcp_pool֮��
			target = c.target.target          -- Ҳ���ǰѱ�������target = '_cbi'����target�����к�������
		end
	end

	if c and (c.index or type(target) == "function") then
		ctx.dispatched = c
		ctx.requested = ctx.requested or ctx.dispatched
	end

	if c and c.index then -- indexΪĿ¼·������Ҫ������ת
		local tpl = require "luci.template"

		if util.copcall(tpl.render, "indexer", {}) then -- ���ݲ����ض���ָ����������
			return true
		end
	end

	if type(target) == "function" then 
		util.copcall(function()
			local oldenv = getfenv(target)
			local module = require(c.module)
			local env = setmetatable({}, {__index=

			function(tbl, key)
				return rawget(tbl, key) or module[key] or oldenv[key]
			end})

			setfenv(target, env) -- ����target��ǰ��������
		end)

		local ok, err
		if type(c.target) == "table" then -- ִ�и������ʹ�����
			ok, err = util.copcall(target, c.target, unpack(args))  -- call template cbi form arcombine firstchild alias
		else
			ok, err = util.copcall(target, unpack(args))          
		end
		assert(ok, --- function-target, expection
		       "Failed to execute " .. (type(c.target) == "function" and "function" or c.target.type or "unknown") ..
		       " dispatcher target for entry '/" .. table.concat(request, "/") .. "'.\n" ..
		       "The called action terminated with an exception:\n" .. tostring(err or "(unknown)"))
	else
		local root = node() --- index can not find
		if not root or not root.target then
			error404("No root node was registered, this usually happens if no module was installed.\n" ..
			         "Install luci-mod-admin-full and retry. " ..
			         "If the module is already installed, try removing the /tmp/luci-indexcache file.")
		else
			error404("No page is registered at '/" .. table.concat(request, "/") .. "'.\n" ..
			         "If this url belongs to an extension, make sure it is properly installed.\n" ..
			         "If the extension was recently installed, try removing the /tmp/luci-indexcache file.")
		end
	end
end

-- + Generate the dispatching index using the native file-cache based strategy.
-- $ 
function createindex() -- ֱ�ӵ�controller�����ռ����е�*.lua����
	local controllers = { }
	local base = "%s/controller/" % util.libpath()
	local _, path

	for path in (fs.glob("%s*.lua" % base) or function() end) do  -- controllerĿ¼������lua�ļ�
		controllers[#controllers+1] = path
	end

	for path in (fs.glob("%s*/*.lua" % base) or function() end) do -- controllerĿ¼����Ŀ¼������lua�ļ�
		controllers[#controllers+1] = path
	end
-- �����ļ��ڣ����ػ����ļ�
-- /tmp/luci-indexcache ���غ���������:
-- luci.controller.commands        function: 0x128bc40
-- luci.controller.admin.uci       function: 0x129e2e0
-- luci.controller.luci_statistics.luci_statistics function: 0x1279470
-- luci.controller.admin.status    function: 0x12ad5a0
-- luci.controller.qos     function: 0x12ad990
-- luci.controller.firewall        function: 0x12ae300
-- luci.controller.admin.index     function: 0x12aea50
-- luci.controller.admin.servicectl        function: 0x12aee10
-- luci.controller.admin.network   function: 0x12b12e0
-- luci.controller.ddns    function: 0x12b3590
-- luci.controller.admin.filebrowser       function: 0x12b2970
-- luci.controller.admin.system    function: 0x12b26c0

	if indexcache then -- indexcache <-> /tmp/luci-indexcache ��������˸��ļ�·��
		local cachedate = fs.stat(indexcache, "mtime") 
		if cachedate then
			local realdate = 0
			for _, obj in ipairs(controllers) do
				local omtime = fs.stat(obj, "mtime")
				realdate = (omtime and omtime > realdate) and omtime or realdate
			end

			if cachedate > realdate and sys.process.info("uid") == 0 then
				assert(
					sys.process.info("uid") == fs.stat(indexcache, "uid")
					and fs.stat(indexcache, "modestr") == "rw-------",
					"Fatal: Indexcache is not sane!"
				)
-- ����loadfile(indexcache)() ���ز�ִ��
				index = loadfile(indexcache)() -- indexcache�ļ����ڣ���mtime��������ӻ����ļ�
				return index
			end
		end
	end

	index = {}
-- �����ļ����ڣ��ؽ������ļ�
	for _, path in ipairs(controllers) do
		local modname = "luci.controller." .. path:sub(#base+1, #path-4):gsub("/", ".")
		local mod = require(modname) -- ���ģ��
		assert(mod ~= true,
		       "Invalid controller file found\n" ..
		       "The file '" .. path .. "' contains an invalid module line.\n" ..
		       "Please verify whether the module name is set to '" .. modname ..
		       "' - It must correspond to the file path!")

		local idx = mod.index -- index����
		assert(type(idx) == "function",
		       "Invalid controller file found\n" ..
		       "The file '" .. path .. "' contains no index() function.\n" ..
		       "Please make sure that the controller contains a valid " ..
		       "index function and verify the spelling!")

		index[modname] = idx  -- ����ģ���index�����ĵ�ַ �� controll/*.lua ����֮���Ӧ��ϵ
	end

	if indexcache then
		local f = nixio.open(indexcache, "w", 600)  -- �½�/tmp/luci-indexcache��д����������
		f:writeall(util.get_bytecode(index))       --index����
		f:close()
	end
end

-- createtree()��������Ҫ�ҵ�controllerĿ¼�����е�.lua�ļ������ҵ����е�index()����ִ�У��Ӷ�����һ��node-tree��
-- nodeindex ������¼��һЩindex������ �� nodetree����ִ����entry֮�����������������νṹ��nodes{}
-- Build the index before if it does not exist yet.
-- + Create the dispatching tree from the index. Build the index before if it does not exist yet.
function createtree()
	if not index then
		createindex() -- ������path��suff���ж�����Ȼ����벻ͬ��֧��
	end

	local ctx  = context
	local tree = {nodes={}, inreq=true}
	local modi = {}

	ctx.treecache = setmetatable({}, {__mode="v"}) -- ��treecache���value��˵��������
	ctx.tree = tree
	ctx.modifiers = modi

	-- Load default translation
	require "luci.i18n".loadc("base")

	local scope = setmetatable({}, {__index = luci.dispatcher}) -- �Ҳ���ֵ������£�����luci.dispater����

	for k, v in pairs(index) do
		scope._NAME = k         -- kΪ�ļ���
		setfenv(v, scope)       -- scope���Ի��luci.dispatcher�����⺯���ͱ���
		v()                     -- ִ��ÿ��ģ���index
	end

	local function modisort(a,b)
		return modi[a].order < modi[b].order
	end
	
-- ������Щ���벻ִ��
	for _, v in util.spairs(modi, modisort) do
		scope._NAME = v.module
		setfenv(v.func, scope)
		v.func()
	end
	
-- _create_node(path) �� index()->entry()->node()->_createnode ���б���
	return tree
end

-- + Register a tree modifier.
-- # func: Modifier function
-- # order: Modifier order value (optional)
-- $ 
function modifier(func, order)
	context.modifiers[#context.modifiers+1] = {
		func = func,
		order = order or 0,
		module
			= getfenv(2)._NAME
	}
end

-- [[ assign({"freifunk", "olsr"}, {"admin", "status", "olsr"}, _("OLSR"), 30)
-- + Clone a node of the dispatching tree to another position.
-- # path: Virtual path destination
-- # clone: Virtual path source
-- # title: Destination node title (optional)
-- # order: Destination node order value (optional)
-- $ Dispatching tree node
function assign(path, clone, title, order)
	local obj  = node(unpack(path))
	obj.nodes  = nil
	obj.module = nil

	obj.title = title
	obj.order = order

	setmetatable(obj, {__index = _create_node(clone)})

	return obj
end
-- ���ӷ�����alias('admin') firstchild() assign()
-- �������������ַ���һ������һ��·����Ҷ�ڵ�leaf��
--  Call��cbi��form��template�⼸�ַ�����ִ�е�ԭ�������ͬ�������ն�������������http-response����
-- ������html�ļ�����������luci.template.render()��luci.http.redirect()�Ⱥ���


-- Path:����·��
-- Target:Ŀ�꺯������
----alias ��ָ����entry�ı���
----from  ���õ�ĳһ��view
----cbi   ����ĳһ��model
----call   ֱ�ӵ��ú���
-- Title���˵����ı���ֱ�����string������ʻ���_("string"),�͹��ʻ��ˣ�
-- Order��ͬ���˵��£��˲˵����λ�ã��Ӵ�С��
-- + Create a new dispatching node and define common parameters.
-- # path: Virtual path
-- # target: Target function to call when dispatched.
-- # title: Destination node title
-- # order: Destination node order value (optional)
-- $ Dispatching tree node
-- Attributes
---- myentry.i18n
---- myentry.dependent
---- myentry.leaf
---- myentry.sysauth
---- myentry.hidden
-- Parameters
---- myentry.noheader
---- myentry.nofooter
---- myentry.on_success_to
---- myentry.on_changed_to
---- myentry.on_valid_to
---- myentry.autoapply
---- hideresetbtn Hide the reset button on the footer ��cbi
---- hideapplybtn Hide the apply button on the footer ��cbi
---- hidesavebtn hide the save button on the footer   ��cbi
function entry(path, target, title, order)
	local c = node(unpack(path)) -- ����һ�������е�Ԫ��Ϊ·������
-- unpack����path�е�����ֵ��������node��������Ȼ�����node���Σ���node�ڵ㴴������

	c.target = target -- ��ֵ����ȥ�󣬸տ�ʼ����node-tree��ʱ��alias(..)��������entry(...)����֮ǰ���ã�Ȼ��alias()�����е���dispatch(req)��
	c.title  = title
	c.order  = order -- ͬһ���ڵ�֮���˳��ԽСԽ��ǰ����֮Խ���󣨿�ѡ��
	c.module = getfenv(2)._NAME -- _NAME = 'luci.template' ���� _NAME = 'luci.http.protocol'

	return c
end

-- enabling the node.
-- + Fetch or create a dispatching node without setting the target module or enabling the node.
-- # ...: Virtual path
-- $ Dispatching tree node
function get(...)
	return _create_node({...})
end

-- + Fetch or create a new dispatching node.
-- # ...: Virtual path
-- $ Dispatching tree node
function node(...)
	local c = _create_node({...}) -- ����һ��node�ڵ㣬���븸�ڵ㽨������

	c.module = getfenv(2)._NAME
	c.auto = nil

	return c
end

-- node->nodes{��parent��children֮�������ϵ}
function _create_node(path)
	if #path == 0 then -- ���·��Ϊ��·�����Ӧ���ڵ�
		return context.tree
	end

	local name = table.concat(path, ".")
	local c = context.treecache[name] -- �鿴�������Ƿ���ڴ˽ڵ�

	if not c then
		local last = table.remove(path) -- ɾ��·��Ŀ¼�е����һ���ļ���ת��ɸ�Ŀ¼
		local parent = _create_node(path) -- �������ڵ�(�����ݹ����)

		c = {nodes={}, auto=true} -- �½��ڵ�
		-- the node is "in request" if the request path matches
		-- at least up to the length of the node path
		if parent.inreq and context.path[#path+1] == last then
		  c.inreq = true
		end
		parent.nodes[last] = c      -- Ŀ¼���ƺͽڵ�֮��Ķ�Ӧ��ϵ lastΪĿ¼�� cΪnode��
		context.treecache[name] = c -- ���ڵ㻺�浽treecache����  name Ϊ��ֽṹ
	end
	return c
end

-- Subdispatchers --
-- 
function _firstchild()
   local path = { unpack(context.path) } -- context.path ����·��
   local name = table.concat(path, ".")
   local node = context.treecache[name] -- �����а�����������Ϣ

   local lowest
   if node and node.nodes and next(node.nodes) then -- nodes�ܰ�����һ��ڵ������������Ϣ
	  local k, v
	  for k, v in pairs(node.nodes) do -- ��Ŀ¼�����в���order��С����һ��
		 if not lowest or
			(v.order or 100) < (node.nodes[lowest].order or 100)
		 then
			lowest = k
		 end
	  end
   end

   assert(lowest ~= nil,
		  "The requested node contains no childs, unable to redispatch")

   path[#path+1] = lowest -- ����ȡ�ļ������Ƹ�ֵ��׷�ӵ�pathβ��
   dispatch(path) -- ͨ��dispatch���ȴ�·����Ϣ
end

-- + Alias the first (lowest order) page automatically
function firstchild()
   return { type = "firstchild", target = _firstchild }
end
--[[
target = {
    target = function: 0x25d2f40
    type = 'firstchild'
}
]]--

-- alias("admin", "system", "system")
-- + Create a redirect to another dispatching node.
-- # ...: Virtual path destination
-- dispatch������������Ϊ·������
function alias(...) -- ���ȱ���ָ���·��
	local req = {...}
	return function(...)
		for _, r in ipairs({...}) do
			req[#req+1] = r
		end

		dispatch(req)
	end
end

-- + Rewrite the first x path values of the request.
-- # n: Number of path values to replace
-- # ...: Virtual path to replace removed path values with
-- $ 
function rewrite(n, ...)
	local req = {...}
	return function(...)
		local dispatched = util.clone(context.dispatched)

		for i=1,n do
			table.remove(dispatched, 1)
		end

		for i, r in ipairs(req) do
			table.insert(dispatched, i, r)
		end

		for _, r in ipairs({...}) do
			dispatched[#dispatched+1] = r
		end

		dispatch(dispatched)
	end
end


local function _call(self, ...) -- self��ʾtarget��
	local func = getfenv()[self.name] -- ��ȡ��ǰ���������ļ���·��
	assert(func ~= nil,
	       'Cannot resolve function "' .. self.name .. '". Is it misspelled or local?')

	assert(type(func) == "function",
	       'The symbol "' .. self.name .. '" does not refer to a function but data ' ..
	       'of type "' .. type(func) .. '".')

	if #self.argv > 0 then
		return func(unpack(self.argv), ...) -- ���õ�ǰ��������·���µĶ�Ӧ����
	else
		return func(...) -- ���õ�ǰ��������·���µĶ�Ӧ����
	end
end

-- + Create a function-call dispatching target.
-- # name: Target function of local controller
-- # ...: Additional parameters passed to the function
-- $ 
-- call(ͨ�������ռ����ݣ�Ȼ��ͨ��template���ռ��������ݷ���web)    ����html����
-- call(ͨ�������ռ����ݣ��ȴ�XHR.poll �������󣬽�json���ݷ���web) ����json����
-- call(�����ϴ��ļ����ݣ�����http.setfilehandler ʵ���ļ��ϴ�����
function call(name, ...) -- ��������ʾ����ִ��dispatch()ʱ�򣬵���_call()������
	return {type = "call", argv = {...}, name = name, target = _call} 
end
--[[
target = {
    target = function: 0x25d3010
    type = 'call'
    argv = {}
    name = 'action_iptables'
}
]]--

-- post_on({ set = true }, "action_clock_status") -- action_clock_status ���մ���set����; XHR.poll����XHR.post
-- XHR�����첽�������� -- ������������
-- post_on({ exec = "1" }, "action_packages")     -- action_packages  ���մ���exec����
-- <form method="post" action="<%=REQUEST_URI%>"> ���͵����� -- ������������
-- <input type="hidden" name="exec" value="1" />
function post_on(params, name, ...)
	return {
		type = "call",
		post = params,
		argv = { ... }, -- ��ֵ��handler����
		name = name,
		target = _call
	}
end

function post(...)
	return post_on(true, ...) -- ���õ�һ��ֵΪtrue
end

-- ͨ��һ��ҳ��ֻ�ܽ����������get����
local _template = function(self, ...) -- self��ʾtarget��
	require "luci.template".render(self.view)
end

-- ��ִ��dispatch()������ʱ����ִ��_template = function (self, ...) require "luci.template".render(self.view) ������admin_status/index.htm
-- + Create a template render dispatching target.
-- # name: Template to be rendered
-- ������status���͵�չʾҳ��
function template(name)
	return {type = "template", view = name, target = _template}
end
--[[
target = {
    view = 'admin_status/routes'
    type = 'template'
    target = function: 0x25d35c0
}
]]--

-- config �Զ��ҳ����п���
-- maps.option �Ե���ҳ����п��Ʋ���
-- redirect ���ҳ�������Ŀ��Ʋ���
-- cbi("adblock/overview_tab", {hideresetbtn=true, hidesavebtn=true}) ���Ӳ���
local function _cbi(self, ...) -- self��ʾtarget��
	local cbi = require "luci.cbi"
	local tpl = require "luci.template"
	local http = require "luci.http"

	local config = self.config or {}       -- ��cbi()���صĵڶ���������config
	local maps = cbi.load(self.model, ...) -- ��������������load(),Ȼ���maps  
                                           -- ��cbi.lua�ļ��У�model��ʵ����·����load·��

	local state = nil
-- ��������һ��forѭ����ÿһ��node������Ҫmap������ܣ�Ȼ��һ��һ��Ļ��ؼ���
	for i, res in ipairs(maps) do 
		res.flow = config  -- config���û�Ӱ������ҳ��
		local cstate = res:parse() -- ����Map.parse(self, readinput,...)
		                           -- ����Node.parse(self, ...),(uci��Ҫ����luci�������ݽ�����ƽ̨��)
		if cstate and (not state or cstate < state) then
			state = cstate
		end
	end

	local function _resolve_path(path)
		return type(path) == "table" and build_url(unpack(path)) or path
	end

	if config.on_valid_to and state and state > 0 and state < 2 then
		http.redirect(_resolve_path(config.on_valid_to))
		return
	end

	if config.on_changed_to and state and state > 1 then
		http.redirect(_resolve_path(config.on_changed_to))
		return
	end

	if config.on_success_to and state and state > 0 then
		http.redirect(_resolve_path(config.on_success_to))
		return
	end

	if config.state_handler then
		if not config.state_handler(state, maps) then
			return
		end
	end

	http.header("X-CBI-State", state or 0) -- �����ݰ�ͷ�����, �����ֶκ������ֶε�ֵ

	if not config.noheader then -- form��luci/header.htm�ļ���cbi��luci/view/cbi/header.htm
		tpl.render("cbi/header", {state = state}) -- cbi/headerΪԭʼ��header.htm׷����һ��post���͵�ͷ
	end

	local redirect
	local messages
	local applymap   = false
	local pageaction = true
	local parsechain = { }

	for i, res in ipairs(maps) do
		if res.apply_needed and res.parsechain then
			local c
			for _, c in ipairs(res.parsechain) do
				parsechain[#parsechain+1] = c
			end
			applymap = true
		end

		if res.redirect then -- ���map��redirect��ʱ��ֻ�е�һ��direct��Ч
			redirect = redirect or res.redirect
		end

		if res.pageaction == false then -- ��cbi/footer.htm�еİ�ť���п��ƣ��ܿ���
			pageaction = false
		end

		if res.message then -- ���map��message��Ϣ���ۼ���ʾ�ģ�
			messages = messages or { }
			messages[#messages+1] = res.message
		end
	end

	for i, res in ipairs(maps) do -- ����ÿ��map
		res:render({
			firstmap   = (i == 1), -- �Ƿ��һ��maps
			applymap   = applymap, -- �Ƿ���Ҫapply���й�����uci�����ļ�
			redirect   = redirect, -- �Ƿ���Ҫ�ض���
			messages   = messages, -- ���message
			pageaction = pageaction, -- �Եײ��ύ�İ�ť���п���
			parsechain = parsechain -- ������uci�����ļ�
		})
	end

	if not config.nofooter then -- cbi���õİ�ť��Դ��cbi/footer.htm ��form���õİ�ť��Դ��simpleform��Ӧ��template
		tpl.render("cbi/footer", {
			flow       = config, -- ȫ�ֿ���
			pageaction = pageaction, -- �Եײ��ύ�İ�ť�����ܿ���
			redirect   = redirect, -- �Ƿ���Ҫ�ض���
			state      = state, -- ��ǰ��״̬
			autoapply  = config.autoapply -- �Զ��ύ����
		})
	end
end

-- ���ȣ�cbi()������ִ�У�return {type = 'cbi', config = config, model = model, target = _cbi}��仰��
-- ��ʼ��ʱ��_cbi�������ᱻִ�У�ֻ�е���dispatch()��������ſ���ִ�С�
-- + Create a CBI model dispatching target.
-- # model: CBI model to be rendered
-- cbi("adblock/overview_tab", {hideresetbtn=true, hidesavebtn=true}) ���Ӳ���
function cbi(model, config) -- config �����ݴ��ݸ�template
	return {
		type = "cbi",
		post = { ["cbi.submit"] = "1" },
		config = config, -- {hideresetbtn=true, hidesavebtn=true}
		model = model,
		target = _cbi -- _cbi Ϊ����
	}
end
--[[
target = {
    target = function: 0x25d3660
    type = 'cbi'
    model = 'tau_hostname'
}
]]--

-- _cbi����һ���ļ��а�������Map����_arcombine�ǰ�����Map��ϵ�һ�𣻹ؼ���ͬ����linker��һ��
local function _arcombine(self, ...) -- self��ʾtarget��
	local argv = {...}
	local target = #argv > 0 and self.targets[2] or self.targets[1] -- ������������ȵ��õڶ�������
	setfenv(target.target, self.env)
	target:target(unpack(argv))     -- һ������һ��ִ����Ӧ�ĺ���,
end

-- ����dispatcher.lua�ļ���function arcombine(trg1, trg2)
-- + Create a combined dispatching target for non argv and argv requests.
-- # trg1: Overview Target (non argv requests)
-- # trg2: Detail Target   (argv requests)
-- ���������ú�չʾ����ҳ����������ҳ�渺��չʾ����ӡ�ɾ��������ҳ�渨���޸����õ�ϸ��
function arcombine(trg1, trg2) -- argv combine
	return {type = "arcombine", env = getfenv(), target = _arcombine, targets = {trg1, trg2}}
end
--[[
target = {
	env = {*}
	type = 'arcombine'
	targets = {*}
	target = function: 0x25d3700
}
]]--


-- ��ִ��dispatch()����ʱ��ִ��_form()������
local function _form(self, ...) -- self��ʾtarget��
	local cbi = require "luci.cbi"
	local tpl = require "luci.template"
	local http = require "luci.http"

	local maps = luci.cbi.load(self.model, ...)
	local state = nil

	for i, res in ipairs(maps) do
		local cstate = res:parse()
		if cstate and (not state or cstate < state) then
			state = cstate -- ��Сֵ
		end
	end
-- _cbi����ʹ�õ�view/cbi/header.htm �� view/cbi/footer.htm ��formʹ��ϵͳ�ṩ��
	http.header("X-CBI-State", state or 0) -- �����ݰ�ͷ�����, �����ֶκ������ֶε�ֵ
	tpl.render("header") -- Ȼ�����Template(name):reader()����header.htm
	for i, res in ipairs(maps) do
		res:render()
	end
	tpl.render("footer") -- ҳ�����footer.htm 
end

-- + Create a CBI form model dispatching target.
-- # model: CBI form model tpo be rendered
-- form��֧�ֲ������ݣ���cbi����֧�ֱ��������
function form(model)
	return { -- ���cbiû��config���ѡ��
		type = "cbi",
		post = { ["cbi.submit"] = "1" },
		model = model,  -- ����cbi�����ļ�
		target = _form
	}
end

-- + Access the luci.i18n translate() api.
-- # text: Text to translate
translate = i18n.translate

-- This function does not actually translate the given argument but
-- is used by build/i18n-scan.pl to find translatable entries.
function _(text)
	return text
end
