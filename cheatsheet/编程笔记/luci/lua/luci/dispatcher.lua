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


function error404(message)
	http.status(404, "Not Found")
	message = message or "Not Found"

	require("luci.template")
	if not util.copcall(luci.template.render, "error404") then
		http.prepare_content("text/plain")
		http.write(message) -- 返回404内容
	end
	return false
end

function error500(message)
	util.perror(message)
	if not context.template_header_sent then
		http.status(500, "Internal Server Error")
		http.prepare_content("text/plain")
		http.write(message) -- 返回500内容
	else
		require("luci.template")
		if not util.copcall(luci.template.render, "error500", {message=message}) then
			http.prepare_content("text/plain")
			http.write(message)  -- 返回500内容
		end
	end
	return false
end

-- 接收http.Request到http.context.request; 更新context.request内容为PATH_INFO内容，
-- 然后由dispath处理 context.request请求
function httpdispatch(request, prefix)
	http.context.request = request -- 获取从http.lua中获得数据信息

	local r = {}
	context.request = r -- 更新了context 中的r字段的内容

	local pathinfo = http.urldecode(request:getenv("PATH_INFO") or "", true) -- 返回环境变量PATH_INFO

	if prefix then
		for _, node in ipairs(prefix) do
			r[#r+1] = node
		end
	end

	for node in pathinfo:gmatch("[^/]+") do  -- 模式匹配/ 开头的字符串 
		r[#r+1] = node
	end
    -- context.request 为只包含admin元素的数组
	local stat, err = util.coxpcall(function()
		dispatch(context.request) -- 此时context.request中满载了PATH_INFO信息
	end, error500)

	http.close()

	--context._disable_memtrace()
end

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

-- 判断连接安全性
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
			util.ubus("session", "set", { -- 调用ubus call session set 操作
				ubus_rpc_session = login.ubus_rpc_session,
				values = { token = sys.uniqueid(16) }
			})

			return session_retrieve(login.ubus_rpc_session)
		end
	end

	return nil, nil
end

function dispatch(request)
	--context._disable_memtrace = require "luci.debug".trap_memtrace("l")
	local ctx = context -- util.threadlocal()
	ctx.path = request -- 请求中的路径

	local conf = require "luci.config" -- uci处理模块; 读取配置文件，获取luci配置信息
	assert(conf.main,                  -- main为luci的主配置
		"/etc/config/luci seems to be corrupt, unable to find section 'main'")
-- A. 设置语言相关信息
	local i18n = require "luci.i18n"
	local lang = conf.main.lang or "auto"  -- /etc/config/luci/{lang} 
	if lang == "auto" then                                       -- html lang="zh-cn"
		local aclang = http.getenv("HTTP_ACCEPT_LANGUAGE") or "" -- HTTP_ACCEPT_LANGUAGE 语言
		for lpat in aclang:gmatch("[%w-]+") do
			lpat = lpat and lpat:gsub("-", "_") -- 将平台语言中的中划线换成下划线
			if conf.languages[lpat] then -- 平台指定的语言
				lang = lpat
				break
			end
		end
	end
	if lang == "auto" then
		lang = i18n.default -- 默认设定语言
	end
	i18n.setlanguage(lang) -- 设置语言
--  B.创建node-tree节点树结构  
	local c = ctx.tree
	local stat
	if not c then
		c = createtree()     -- 此函数从controller下的index函数来创建node-tree结构文件
	end

	local track = {} -- 每一层把找到的node信息放在这个track()中
	local args = {}
	ctx.args = args
	ctx.requestargs = ctx.requestargs or args -- 请求参数
	local n
	local preq = {}
	local freq = {}
--根据请求路径得到nodetree的路径信息
	for i, s in ipairs(request) do
		preq[#preq+1] = s
		freq[#freq+1] = s
		c = c.nodes[s]
		n = i
		if not c then
			break
		end
							  -- 遍历路径的所有node对象
		util.update(track, c) -- 将node节点的属性全部设置给track, 根节点而言就有了sysauth属性

		if c.leaf then -- 叶子节点的时候
			break
		end
	end

	if c and c.leaf then
		for j=n+1, #request do
			args[#args+1] = request[j] -- 添加访问目录
			freq[#freq+1] = request[j] -- 添加访问目录
		end
	end

	ctx.requestpath = ctx.requestpath or freq
	ctx.path = preq

	if track.i18n then
		i18n.loadc(track.i18n)
	end
-- C.需要显示的部分
	-- Init template engine
	if (c and c.index) or not track.notemplate then
		local tpl = require("luci.template")
		local media = track.mediaurlbase or luci.config.main.mediaurlbase
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
-- 初始化模板
-- 当点击登录后，页面会跳转到/,接着/admin,
-- 如果需要认证，那么接下来会弹出htmlauth.htm页面，然后
-- 如果没有验证成功，则继续本页面，
-- 如果成功了，那么继续跳转/,然后admin/
-- 此时post来了信息，然后alias到entry.order最小的那个node，
-- 很显然是/admin/status.lua,然后status这个node会alias到overview这个node。
-- 最主要的还是在diapatcher.lua文件中的dispatch()的认证部分。
		tpl.context.viewns = setmetatable({ -- view处理中write函数重定向
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
		}, {__index=function(table, key)
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
-- D.认证 此部分和192.168.100.1存在较大差异
	if track.sysauth then     -- 会话管理 template 认证
		local authen = track.sysauth_authenticator -- admin/index.lua:18: page.sysauth_authenticator = "htmlauth"
		local _, sid, sdat, default_user, allowed_users

		if type(authen) == "string" and authen ~= "htmlauth" then
			error500("Unsupported authenticator %q configured" % authen)
			return
		end

		if type(track.sysauth) == "table" then -- page.sysauth = "root" ， 如果为表，允许多用户登录
			default_user, allowed_users = nil, track.sysauth
		else
			default_user, allowed_users = track.sysauth, { track.sysauth } -- 由于sysauth为字符串，所有都为root
		end

		if type(authen) == "function" then -- page.sysauth_authenticator = "htmlauth"
			_, sid = authen(sys.user.checkpasswd, allowed_users)
		else
			sid = http.getcookie("sysauth") -- 由于为字符串，因此执行此流程
		end
        -- 
		sid, sdat = session_retrieve(sid, allowed_users) -- 从ubus中获取允许用户的sid,如果不存在则进行认证过程

		if not (sid and sdat) and authen == "htmlauth" then
			local user = http.getenv("HTTP_AUTH_USER") -- 获取用户名 环境变量
			local pass = http.getenv("HTTP_AUTH_PASS") -- 获取密码   环境变量

			if user == nil and pass == nil then
				user = http.formvalue("luci_username") -- 获取用户名 URL参数 input中的luci_username
				pass = http.formvalue("luci_password") -- 获取密码   URL参数 input中的luci_password
			end

			sid, sdat = session_setup(user, pass, allowed_users) -- 虽然sid和sdat不存在，但是authen确实等于htmlauth

			if not sid then
				local tmpl = require "luci.template"

				context.path = {}

				http.status(403, "Forbidden")
				tmpl.render(track.sysauth_template or "sysauth", { -- 跳转到认证页面
					duser = default_user,  -- duser参数
					fuser = user           -- fuser参数
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

	if c and require_post_security(c.target) then
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
	if c then -- 根据index.lua的判断，target等firstchild()函数
		if type(c.target) == "function" then -- 当c.target类型为函数时候
			target = c.target
		elseif type(c.target) == "table" then -- 当c.target类型为table时候
			target = c.target.target 的       -- 也就是把表中属性target = '_cbi'给了target，进行后续处理。
		end
	end

	if c and (c.index or type(target) == "function") then
		ctx.dispatched = c
		ctx.requested = ctx.requested or ctx.dispatched
	end

	if c and c.index then
		local tpl = require "luci.template"

		if util.copcall(tpl.render, "indexer", {}) then
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

			setfenv(target, env)
		end)

		local ok, err
		if type(c.target) == "table" then 
			ok, err = util.copcall(target, c.target, unpack(args))  
		else
			ok, err = util.copcall(target, unpack(args))          -- call template cbi form arcombine firstchild alias
		end
		assert(ok,
		       "Failed to execute " .. (type(c.target) == "function" and "function" or c.target.type or "unknown") ..
		       " dispatcher target for entry '/" .. table.concat(request, "/") .. "'.\n" ..
		       "The called action terminated with an exception:\n" .. tostring(err or "(unknown)"))
	else
		local root = node()
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

function createindex() -- 直接到controller下面收集所有的*.lua报文
	local controllers = { }
	local base = "%s/controller/" % util.libpath()
	local _, path

	for path in (fs.glob("%s*.lua" % base) or function() end) do  -- controller目录下所有lua文件
		controllers[#controllers+1] = path
	end

	for path in (fs.glob("%s*/*.lua" % base) or function() end) do -- controller目录的子目录下所有lua文件
		controllers[#controllers+1] = path
	end
-- 缓存文件在，加载缓存文件
-- /tmp/luci-indexcache 加载后内容如下:
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

	if indexcache then -- indexcache <-> /tmp/luci-indexcache 如果配置了该文件路径
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

				index = loadfile(indexcache)() -- indexcache文件存在，且mtime正常，添加缓存文件
				return index
			end
		end
	end

	index = {}
-- 缓存文件不在，重建缓存文件
	for _, path in ipairs(controllers) do
		local modname = "luci.controller." .. path:sub(#base+1, #path-4):gsub("/", ".")
		local mod = require(modname) -- 添加模块
		assert(mod ~= true,
		       "Invalid controller file found\n" ..
		       "The file '" .. path .. "' contains an invalid module line.\n" ..
		       "Please verify whether the module name is set to '" .. modname ..
		       "' - It must correspond to the file path!")

		local idx = mod.index -- index函数
		assert(type(idx) == "function",
		       "Invalid controller file found\n" ..
		       "The file '" .. path .. "' contains no index() function.\n" ..
		       "Please make sure that the controller contains a valid " ..
		       "index function and verify the spelling!")

		index[modname] = idx  -- 保存模块的index函数的地址
	end

	if indexcache then
		local f = nixio.open(indexcache, "w", 600)  -- 新建/tmp/luci-indexcache，写入所有数据
		f:writeall(util.get_bytecode(index))       --index序列
		f:close()
	end
end

-- nodeindex 仅仅记录了一些index函数， 而 nodetree则是执行了entry之后，生成了完整的树形结构的nodes{}
-- Build the index before if it does not exist yet.
function createtree()
	if not index then
		createindex() -- 定义了path、suff，判断条件然后进入不同分支，
	end

	local ctx  = context
	local tree = {nodes={}, inreq=true}
	local modi = {}

	ctx.treecache = setmetatable({}, {__mode="v"}) -- 对treecache表的value来说是弱引用
	ctx.tree = tree
	ctx.modifiers = modi

	-- Load default translation
	require "luci.i18n".loadc("base")

	local scope = setmetatable({}, {__index = luci.dispatcher}) -- 找不到值的情况下，调用luci.dispater函数

	for k, v in pairs(index) do
		scope._NAME = k
		setfenv(v, scope)
		v()                     -- 执行每个模块的index
	end

	local function modisort(a,b)
		return modi[a].order < modi[b].order
	end

	for _, v in util.spairs(modi, modisort) do
		scope._NAME = v.module
		setfenv(v.func, scope)
		v.func()
	end

	return tree
end

function modifier(func, order)
	context.modifiers[#context.modifiers+1] = {
		func = func,
		order = order or 0,
		module
			= getfenv(2)._NAME
	}
end

function assign(path, clone, title, order)
	local obj  = node(unpack(path))
	obj.nodes  = nil
	obj.module = nil

	obj.title = title
	obj.order = order

	setmetatable(obj, {__index = _create_node(clone)})

	return obj
end
-- Path:虚拟路径
-- Target:目标函数调用
----alias是指向别的entry的别名
----from调用的某一个view
----cbi调用某一个model
----call直接调用函数
-- Title：菜单的文本，直接添加string不会国际化，_("string"),就国际化了，
-- Order：同级菜单下，此菜单项的位置，从大到小。
function entry(path, target, title, order)
	local c = node(unpack(path)) -- 生成一个表，表中的元素为路径名称
-- unpack返回path中的所有值，并传给node做参数，然后调用node两次，将node节点创建出来

	c.target = target -- 将值传进去后，刚开始构造node-tree的时候，alias(..)函数会在entry(...)函数之前调用，然后alias()函数中调用dispatch(req)。
	c.title  = title
	c.order  = order -- 同一级节点之间的顺序，越小越靠前，反之越靠后（可选）
	c.module = getfenv(2)._NAME

	return c
end

-- enabling the node.
function get(...)
	return _create_node({...})
end

function node(...)
	local c = _create_node({...}) -- 创建一个node节点，并与父节点建立关联

	c.module = getfenv(2)._NAME
	c.auto = nil

	return c
end

function _create_node(path)
	if #path == 0 then -- 如果路径为根路径则对应根节点
		return context.tree
	end

	local name = table.concat(path, ".")
	local c = context.treecache[name] -- 查看缓存中是否存在此节点

	if not c then
		local last = table.remove(path) -- 删除路径目录中的最后一个文件，转变成父目录
		local parent = _create_node(path) -- 创建父节点

		c = {nodes={}, auto=true} -- 新建节点
		-- the node is "in request" if the request path matches
		-- at least up to the length of the node path
		if parent.inreq and context.path[#path+1] == last then
		  c.inreq = true
		end
		parent.nodes[last] = c      -- 目录名称和节点之间的对应关系 last为目录名 c为node名
		context.treecache[name] = c -- 将节点缓存到treecache表中  name 为点分结构
	end
	return c
end

-- Subdispatchers --
-- 
function _firstchild()
   local path = { unpack(context.path) } -- context.path 索引路径
   local name = table.concat(path, ".")
   local node = context.treecache[name] -- 索引中包含的索引信息

   local lowest
   if node and node.nodes and next(node.nodes) then -- nodes总包含下一层节点的所有索引信息
	  local k, v
	  for k, v in pairs(node.nodes) do -- 子目录数组中查找order最小的哪一个
		 if not lowest or
			(v.order or 100) < (node.nodes[lowest].order or 100)
		 then
			lowest = k
		 end
	  end
   end

   assert(lowest ~= nil,
		  "The requested node contains no childs, unable to redispatch")

   path[#path+1] = lowest -- 将获取文件夹名称赋值给追加到path尾部
   dispatch(path) -- 通过dispatch调度此路径信息
end

function firstchild()
   return { type = "firstchild", target = _firstchild }
end

-- dispatch函数接收内容为路径数组
function alias(...) -- 调度别名指向的路径
	local req = {...}
	return function(...)
		for _, r in ipairs({...}) do
			req[#req+1] = r
		end

		dispatch(req)
	end
end

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


local function _call(self, ...)
	local func = getfenv()[self.name] -- 获取当前函数所在文件夹路径
	assert(func ~= nil,
	       'Cannot resolve function "' .. self.name .. '". Is it misspelled or local?')

	assert(type(func) == "function",
	       'The symbol "' .. self.name .. '" does not refer to a function but data ' ..
	       'of type "' .. type(func) .. '".')

	if #self.argv > 0 then
		return func(unpack(self.argv), ...) -- 调用当前函数所在路径下的对应函数
	else
		return func(...) -- 调用当前函数所在路径下的对应函数
	end
end

function call(name, ...) -- 当后期显示部分执行dispatch()时候，调用_call()函数，
	return {type = "call", argv = {...}, name = name, target = _call} 
end

function post_on(params, name, ...)
	return {
		type = "call",
		post = params,
		argv = { ... },
		name = name,
		target = _call
	}
end

function post(...)
	return post_on(true, ...)
end

-- 通过一个页面只能接收浏览器的get请求
local _template = function(self, ...)
	require "luci.template".render(self.view)
end

-- 当执行dispatch()函数的时候，则执行_template = function (self, ...) require "luci.template".render(self.view) ，画出admin_status/index.htm
function template(name)
	return {type = "template", view = name, target = _template}
end

-- config 对多个页面进行控制
-- maps.option 对单个页面进行控制部分
-- redirect 多个页面整体后的控制部分
local function _cbi(self, ...)
	local cbi = require "luci.cbi"
	local tpl = require "luci.template"
	local http = require "luci.http"

	local config = self.config or {}       -- 将cbi()返回的第二个参数给config
	local maps = cbi.load(self.model, ...) -- 将第三个参数给load(),然后给maps  
                                           -- 在cbi.lua文件中，model其实就是路径，load路径

	local state = nil
-- 接下来是一个for循环，每一个node首先需要map画出框架，然后一层一层的画控件。
	for i, res in ipairs(maps) do 
		res.flow = config  -- config配置会影响所有页面
		local cstate = res:parse() -- 调用Map.parse(self, readinput,...)
		                           -- 调用Node.parse(self, ...),(uci主要是与luci进行数据交互的平台。)
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

	http.header("X-CBI-State", state or 0)

	if not config.noheader then -- form的luci/header.htm文件，cbi的luci/view/cbi/header.htm
		tpl.render("cbi/header", {state = state}) -- cbi/header为原始的header.htm追加了一个post类型的头
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

		if res.redirect then -- 多个map有redirect的时候，只有第一个direct有效
			redirect = redirect or res.redirect
		end

		if res.pageaction == false then -- 对cbi/footer.htm中的按钮进行控制，总开关
			pageaction = false
		end

		if res.message then -- 多个map的message信息是累加显示的，
			messages = messages or { }
			messages[#messages+1] = res.message
		end
	end

	for i, res in ipairs(maps) do -- 处理每个map
		res:render({
			firstmap   = (i == 1), -- 是否第一个maps
			applymap   = applymap, -- 是否需要apply且有关联的uci配置文件
			redirect   = redirect, -- 是否需要重定向
			messages   = messages, -- 输出message
			pageaction = pageaction, -- 对底部提交的按钮进行控制
			parsechain = parsechain -- 关联的uci配置文件
		})
	end

	if not config.nofooter then -- cbi调用的按钮来源于cbi/footer.htm 而form调用的按钮来源于simpleform对应的template
		tpl.render("cbi/footer", {
			flow       = config, -- 全局控制
			pageaction = pageaction, -- 对底部提交的按钮进行总控制
			redirect   = redirect, -- 是否需要重定向
			state      = state, -- 当前的状态
			autoapply  = config.autoapply -- 自动提交功能
		})
	end
end

-- 首先，cbi()函数先执行，return {type = 'cbi', config = config, model = model, target = _cbi}这句话，
-- 开始的时候，_cbi函数不会被执行，只有到了dispatch()函数里面才可以执行。
-- cbi
function cbi(model, config) -- config 将数据传递给template
	return {
		type = "cbi",
		post = { ["cbi.submit"] = "1" },
		config = config,
		model = model,
		target = _cbi -- _cbi 为函数
	}
end

-- _cbi可以一个文件中包含两个Map，而_arcombine是把两个Map组合到一起；关键不同在于linker不一样
local function _arcombine(self, ...)
	local argv = {...}
	local target = #argv > 0 and self.targets[2] or self.targets[1] -- 都两个总线先调用第二个
	setfenv(target.target, self.env)
	target:target(unpack(argv))     -- 一个接着一个执行相应的函数,
end

-- 调用dispatcher.lua文件中function arcombine(trg1, trg2)
function arcombine(trg1, trg2)
	return {type = "arcombine", env = getfenv(), target = _arcombine, targets = {trg1, trg2}}
end

-- 当执行dispatch()函数时，执行_form()函数，
local function _form(self, ...)
	local cbi = require "luci.cbi"
	local tpl = require "luci.template"
	local http = require "luci.http"

	local maps = luci.cbi.load(self.model, ...)
	local state = nil

	for i, res in ipairs(maps) do
		local cstate = res:parse()
		if cstate and (not state or cstate < state) then
			state = cstate
		end
	end
-- _cbi这里使用的view/cbi/header.htm 和 view/cbi/footer.htm 而form使用系统提供的
	http.header("X-CBI-State", state or 0)
	tpl.render("header") -- 然后调用Template(name):reader()画出header.htm
	for i, res in ipairs(maps) do
		res:render()
	end
	tpl.render("footer") -- 页面输出footer.htm 
end

function form(model)
	return { -- 相比cbi没有config这个选项
		type = "cbi",
		post = { ["cbi.submit"] = "1" },
		model = model,  -- 关联cbi对象文件
		target = _form
	}
end

translate = i18n.translate

-- This function does not actually translate the given argument but
-- is used by build/i18n-scan.pl to find translatable entries.
function _(text)
	return text
end
