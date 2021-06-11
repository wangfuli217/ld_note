-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.admin.index", package.seeall)

function index()
	local root = node()
	if not root.target then -- 调用dispatcher.lua中alias(...)函数，重定向到另外一个节点，在函数将admin节点继续给了req，然后dispatch(req)
		root.target = alias("admin") -- 见failsafe.lua splash.lua和freifunk.lua
		root.index = true
	end

	local page   = node("admin") -- 将admin.写到context.treecache[name]中
	page.target  = firstchild() -- 调用dispatcher.lua中firstchild()函数，return {type = “firstchild”, target = _firstchild},然后调用_firstchild(),将最低顺序的node给dispatch()函数执行。
	page.title   = _("Administration") -- 标题 
	page.order   = 10 -- 顺序  
	-- requires the user to authenticate with a given system user account 
	page.sysauth = "root" -- 认证用户的登录

	-- page.sysauth_authenticator="htmlauth"处理的函数位于luci目录下的dispatcher.lua
	page.sysauth_authenticator = "htmlauth" -- 调用dispatcher.lua中htmlauth()函数，检测登录的合法性。
	page.ucidata = true
	page.index = true

	-- Empty services menu to be populated by addons
	entry({"admin", "services"}, firstchild(), _("Services"), 40).index = true

	entry({"admin", "logout"}, call("action_logout"), _("Logout"), 90)
end

function action_logout()
	local dsp = require "luci.dispatcher"
	local utl = require "luci.util"
	local sid = dsp.context.authsession

	if sid then
		utl.ubus("session", "destroy", { ubus_rpc_session = sid })

		luci.http.header("Set-Cookie", "sysauth=%s; expires=%s; path=%s/" %{
			sid, 'Thu, 01 Jan 1970 01:00:00 GMT', dsp.build_url()
		})
	end

	luci.http.redirect(dsp.build_url())
end
