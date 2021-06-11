-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.qos", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/qos") then
		return
	end
	
	local page

	page = entry({"admin", "network", "qos"}, cbi("qos/qos"), _("QoS"))
	-- protects plugins to be called out of their context if a parent node is missing 
	page.dependent = true --不添加一个顶层导航
	-- dependent=false      添加一个顶层导航
end
