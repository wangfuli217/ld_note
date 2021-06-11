-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.admin.index", package.seeall)

function index()
	local root = node()
	if not root.target then -- ����dispatcher.lua��alias(...)�������ض�������һ���ڵ㣬�ں�����admin�ڵ��������req��Ȼ��dispatch(req)
		root.target = alias("admin") -- ��failsafe.lua splash.lua��freifunk.lua
		root.index = true
	end

	local page   = node("admin") -- ��admin.д��context.treecache[name]��
	page.target  = firstchild() -- ����dispatcher.lua��firstchild()������return {type = ��firstchild��, target = _firstchild},Ȼ�����_firstchild(),�����˳���node��dispatch()����ִ�С�
	page.title   = _("Administration") -- ���� 
	page.order   = 10 -- ˳��  
	-- requires the user to authenticate with a given system user account 
	page.sysauth = "root" -- ��֤�û��ĵ�¼

	-- page.sysauth_authenticator="htmlauth"����ĺ���λ��luciĿ¼�µ�dispatcher.lua
	page.sysauth_authenticator = "htmlauth" -- ����dispatcher.lua��htmlauth()����������¼�ĺϷ��ԡ�
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
