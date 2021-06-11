-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Copyright 2010-2012 Jo-Philipp Wich <jow@openwrt.org>
-- Copyright 2010 Manuel Munz <freifunk at somakoma dot de>
-- Licensed to the public under the Apache License 2.0.

local fs  = require "nixio.fs"
local sys = require "luci.sys"

local inits = { }

for _, name in ipairs(sys.init.names()) do
	local index   = sys.init.index(name)
	local enabled = sys.init.enabled(name)

	if index < 255 then
		inits["%02i.%s" % { index, name }] = {
			name    = name,
			index   = tostring(index),
			enabled = enabled
		}
	end
end

--[[ inits
60.dnsmasq      table: 0x1f13f40
50.uhttpd       table: 0x1f196a0
11.sysctl       table: 0x1f18490
90.openvpn      table: 0x1f17310
90.lldpd        table: 0x1f15dd0
82.cbtc table: 0x1edde80
50.telnet       table: 0x1f19320
79.luci_statistics      table: 0x1f16560
50.dropbear     table: 0x1f14680
00.sysfixtime   table: 0x1f18830
98.sysntpd      table: 0x1f18bf0
35.odhcpd       table: 0x1f16f50
80.gre-tunnel   table: 0x1f14f20
10.system       table: 0x1f18fa0
12.rpcd table: 0x1f17d90
99.socat        table: 0x1f18110
21.conntrackd   table: 0x1ede690
20.network      table: 0x1f16ba0
80.relayd       table: 0x1f17a10
61.ipset-dns    table: 0x1f15670
50.qos  table: 0x1f17690
95.ddns table: 0x1f13b80
12.log  table: 0x1f16180
99.igmpproxy    table: 0x1f152b0
96.led  table: 0x1f15a20
50.cron table: 0x1edea40
80.collectd     table: 0x1ede270
19.firewall     table: 0x1f14b50
95.done table: 0x1f142f0
10.boot table: 0x1eddad0
]]--

m = SimpleForm("initmgr", translate("Initscripts"), translate("You can enable or disable installed init scripts here. Changes will applied after a device reboot.<br /><strong>Warning: If you disable essential init scripts like \"network\", your device might become inaccessible!</strong>"))
m.reset = false
m.submit = false


s = m:section(Table, inits)

i = s:option(DummyValue, "index", translate("Start priority"))
n = s:option(DummyValue, "name", translate("Initscript"))


e = s:option(Button, "endisable", translate("Enable/Disable"))

e.render = function(self, section, scope) -- 决定显示
	if inits[section].enabled then
		self.title = translate("Enabled")
		self.inputstyle = "save"
	else
		self.title = translate("Disabled")
		self.inputstyle = "reset"
	end

	Button.render(self, section, scope)
end

e.write = function(self, section)  -- 决定接受
	if inits[section].enabled then
		inits[section].enabled = false
		return sys.init.disable(inits[section].name)
	else
		inits[section].enabled = true
		return sys.init.enable(inits[section].name)
	end
end


start = s:option(Button, "start", translate("Start")) -- self.option 表示值
start.inputstyle = "apply"
start.write = function(self, section)
	sys.call("/etc/init.d/%s %s >/dev/null" %{ inits[section].name, self.option })
end

restart = s:option(Button, "restart", translate("Restart"))
restart.inputstyle = "reload"
restart.write = start.write

stop = s:option(Button, "stop", translate("Stop"))
stop.inputstyle = "remove"
stop.write = start.write



f = SimpleForm("rc", translate("Local Startup"),
	translate("This is the content of /etc/rc.local. Insert your own commands here (in front of 'exit 0') to execute them at the end of the boot process."))

t = f:field(TextValue, "rcs")
t.rmempty = true
t.rows = 20

function t.cfgvalue()
	return fs.readfile("/etc/rc.local") or ""
end

function f.handle(self, state, data)
	if state == FORM_VALID then
		if data.rcs then
			fs.writefile("/etc/rc.local", data.rcs:gsub("\r\n", "\n"))
		end
	end
	return true
end

return m, f
