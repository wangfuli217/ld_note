-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Copyright 2011 Jo-Philipp Wich <jow@openwrt.org>
-- Licensed to the public under the Apache License 2.0.
-- /admin/system/system
local sys   = require "luci.sys"
local zones = require "luci.sys.zoneinfo"
local fs    = require "nixio.fs"
local conf  = require "luci.config"

local m, s, o
local has_ntpd = fs.access("/usr/sbin/ntpd")

m = Map("system", translate("System"), translate("Here you can configure the basic aspects of your device like its hostname or the timezone."))
m:chain("luci") -- 向map中插入外部的config信息


s = m:section(TypedSection, "system", translate("System Properties"))
s.anonymous = true  -- 是否追加显示 <h3><%=section:upper()%></h3> 
s.addremove = false

s:tab("general",  translate("General Settings"))  -- general table
s:tab("logging",  translate("Logging"))           -- logging table
s:tab("language", translate("Language and Style"))-- language table


--
-- System Properties
--
-- 调用AbstractSection:taboptoin()，然后调用AbstractSection.option(self, ...)，
o = s:taboption("general", DummyValue, "_systime", translate("Local Time"))
o.template = "admin_system/clock_status" -- DummyValue实例后的对象o调用template, 修改以DummyValue的template模板字段


o = s:taboption("general", Value, "hostname", translate("Hostname")) -- Value类实例化的实例给了o
o.datatype = "hostname" -- o连接到cbi文件夹下，datatype.lua文件

function o.write(self, section, value)
	Value.write(self, section, value) -- 调用AbstractValue.write()方法，调用uci:set()写到config文件中
	sys.hostname(value) -- 获得或者更改当前的hostname
end


o = s:taboption("general", ListValue, "zonename", translate("Timezone"))
o:value("UTC")

for i, zone in ipairs(zones.TZ) do
	o:value(zone[1]) -- ListValue中list添加表项
end

function o.write(self, section, value)
	local function lookup_zone(title) -- 函数
		for _, zone in ipairs(zones.TZ) do
			if zone[1] == title then return zone[2] end
		end
	end

	AbstractValue.write(self, section, value)
	local timezone = lookup_zone(value) or "GMT0"
	self.map.uci:set("system", section, "timezone", timezone) -- 写到配置文件 /etc/config/system
	fs.writefile("/etc/TZ", timezone .. "\n")  -- 写到配置文件 /etc/TZ
end


--
-- Logging
--

o = s:taboption("logging", Value, "log_size", translate("System log buffer size"), "kiB")
o.optional    = false
o.placeholder = 16
o.datatype    = "uinteger"

o = s:taboption("logging", Value, "log_ip", translate("External system log server"))
o.optional    = true
o.placeholder = "0.0.0.0"
o.datatype    = "ip4addr"

o = s:taboption("logging", Value, "log_port", translate("External system log server port"))
o.optional    = true
o.placeholder = 514
o.datatype    = "port"

o = s:taboption("logging", ListValue, "log_proto", translate("External system log server protocol"))
o:value("udp", "UDP")
o:value("tcp", "TCP")

o = s:taboption("logging", Value, "log_file", translate("Write system log to file"))
o.optional    = true
o.placeholder = "/tmp/system.log"

o = s:taboption("logging", ListValue, "conloglevel", translate("Log output level"))
o:value(8, translate("Debug"))
o:value(7, translate("Info"))
o:value(6, translate("Notice"))
o:value(5, translate("Warning"))
o:value(4, translate("Error"))
o:value(3, translate("Critical"))
o:value(2, translate("Alert"))
o:value(1, translate("Emergency"))

o = s:taboption("logging", ListValue, "cronloglevel", translate("Cron Log Level"))
o.default = 8
o:value(5, translate("Debug"))
o:value(8, translate("Normal"))
o:value(9, translate("Warning"))


--
-- Langauge & Style
--

o = s:taboption("language", ListValue, "_lang", translate("Language"))
o:value("auto")

local i18ndir = luci.i18n.i18ndir .. "base."
for k, v in luci.util.kspairs(conf.languages) do
	local file = i18ndir .. k:gsub("_", "-")
	if k:sub(1, 1) ~= "." and fs.access(file .. ".lmo") then
		o:value(k, v)
	end
end

function o.cfgvalue(...) -- 获取值予以显示
	return m.uci:get("luci", "main", "lang")
end

function o.write(self, section, value) -- 将设置的值写到配置中
	m.uci:set("luci", "main", "lang", value)
end


o = s:taboption("language", ListValue, "_mediaurlbase", translate("Design"))
for k, v in pairs(conf.themes) do
	if k:sub(1, 1) ~= "." then
		o:value(v, k)
	end
end

function o.cfgvalue(...)
	return m.uci:get("luci", "main", "mediaurlbase")
end

function o.write(self, section, value)
	m.uci:set("luci", "main", "mediaurlbase", value)
end


--
-- NTP
--

if has_ntpd then

	-- timeserver setup was requested, create section and reload page
	if m:formvalue("cbid.system._timeserver._enable") then
		m.uci:section("system", "timeserver", "ntp",
			{
                	server = { "0.openwrt.pool.ntp.org", "1.openwrt.pool.ntp.org", "2.openwrt.pool.ntp.org", "3.openwrt.pool.ntp.org" }
			}
		)

		m.uci:save("system")
		luci.http.redirect(luci.dispatcher.build_url("admin/system", arg[1]))
		return
	end

	local has_section = false
	m.uci:foreach("system", "timeserver", 
		function(s) 
			has_section = true 
			return false
	end)

	if not has_section then

		s = m:section(TypedSection, "timeserver", translate("Time Synchronization"))
		s.anonymous   = true
		s.cfgsections = function() return { "_timeserver" } end

		x = s:option(Button, "_enable")
		x.title      = translate("Time Synchronization is not configured yet.")
		x.inputtitle = translate("Set up Time Synchronization")
		x.inputstyle = "apply"

	else
		
		s = m:section(TypedSection, "timeserver", translate("Time Synchronization"))
		s.anonymous = true
		s.addremove = false

		o = s:option(Flag, "enable", translate("Enable NTP client"))
		o.rmempty = false

		function o.cfgvalue(self)
			return sys.init.enabled("sysntpd")
				and self.enabled or self.disabled
		end

		function o.write(self, section, value)
			if value == self.enabled then
				sys.init.enable("sysntpd")
				sys.call("env -i /etc/init.d/sysntpd start >/dev/null")
			else
				sys.call("env -i /etc/init.d/sysntpd stop >/dev/null")
				sys.init.disable("sysntpd")
			end
		end


		o = s:option(Flag, "enable_server", translate("Provide NTP server"))
		o:depends("enable", "1")


		o = s:option(DynamicList, "server", translate("NTP server candidates")) -- /etc/config/system中list表示方式
		o.datatype = "host(0)"
		o:depends("enable", "1")

		-- retain server list even if disabled
		function o.remove() end

	end
end

return m
