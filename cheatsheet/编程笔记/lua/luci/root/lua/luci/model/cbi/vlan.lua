-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Copyright 2010-2011 Jo-Philipp Wich <jow@openwrt.org>
-- Licensed to the public under the Apache License 2.0.

m = Map("network", translate("Switch"), translate("The network ports on this device can be combined to several <abbr title=\"Virtual Local Area Network\">VLAN</abbr>s in which computers can communicate directly with each other. <abbr title=\"Virtual Local Area Network\">VLAN</abbr>s are often used to separate different network segments. Often there is by default one Uplink port for a connection to the next greater network like the internet and other ports for a local network."))

local fs = require "nixio.fs"
local switches = { }

-- .name    cfg073777
-- .type    switch
-- name     switch0
-- .annoymous true
-- .index    5
-- enable_vlan 1
-- reset  1


m.uci:foreach("network", "switch",
	function(x)
		local sid         = x['.name']
		local switch_name = x.name or sid
		local has_vlan    = nil
		local has_learn   = nil
		local has_vlan4k  = nil
		local has_jumbo3  = nil
		local has_mirror  = nil
		local min_vid     = 0
		local max_vid     = 16
		local num_vlans   = 16
		local cpu_port    = tonumber(fs.readfile("/proc/switch/eth0/cpuport") or 5)
		local num_ports   = cpu_port + 1

		local switch_title
		local enable_vlan4k = false

		-- Parse some common switch properties from swconfig help output.
		local swc = io.popen("swconfig dev %q help 2>/dev/null" % switch_name)
		if swc then

			local is_port_attr = false
			local is_vlan_attr = false

			while true do
				local line = swc:read("*l")
				if not line then break end

				if line:match("^%s+%-%-vlan") then -- 匹配
					is_vlan_attr = true

				elseif line:match("^%s+%-%-port") then -- 匹配
					is_vlan_attr = false
					is_port_attr = true

				elseif line:match("cpu @") then
					switch_title = line:match("^switch%d: %w+%((.-)%)")
					num_ports, cpu_port, num_vlans =
						line:match("ports: (%d+) %(cpu @ (%d+)%), vlans: (%d+)")

					num_ports  = tonumber(num_ports) or  6  -- 8
					num_vlans  = tonumber(num_vlans) or 16  -- 16
					cpu_port   = tonumber(cpu_port)  or  5  -- 6
					min_vid    = 1

				elseif line:match(": pvid") or line:match(": tag") or line:match(": vid") then
					if is_vlan_attr then has_vlan4k = line:match(": (%w+)") end -- pvid

				elseif line:match(": enable_vlan4k") then
					enable_vlan4k = true -- false

				elseif line:match(": enable_vlan") then
					has_vlan = "enable_vlan" -- enable_vlan /etc/config/network swtich节中有此字段

				elseif line:match(": enable_learning") then
					has_learn = "enable_learning" -- nil

				elseif line:match(": enable_mirror_rx") then
					has_mirror = "enable_mirror_rx" -- nil

				elseif line:match(": max_length") then
					has_jumbo3 = "max_length"   -- nil
				end 
			end

			swc:close()
		end


		-- Switch properties
		s = m:section(NamedSection, x['.name'], "switch", -- 以名字标签为关键字的section
			switch_title and translatef("Switch %q (%s)", switch_name, switch_title)
					      or translatef("Switch %q", switch_name))

		s.addremove = false

		if has_vlan then -- 使能和使之实效
			s:option(Flag, has_vlan, translate("Enable VLAN functionality"))
		end

		if has_learn then -- skip
			x = s:option(Flag, has_learn, translate("Enable learning and aging"))
			x.default = x.enabled
		end

		if has_jumbo3 then -- skip
			x = s:option(Flag, has_jumbo3, translate("Enable Jumbo Frame passthrough"))
			x.enabled = "3"
			x.rmempty = true
		end

		-- Does this switch support port mirroring?
		if has_mirror then -- skip
			s:option(Flag, "enable_mirror_rx", translate("Enable mirroring of incoming packets"))
			s:option(Flag, "enable_mirror_tx", translate("Enable mirroring of outgoing packets"))

			local sp = s:option(ListValue, "mirror_source_port", translate("Mirror source port"))
			local mp = s:option(ListValue, "mirror_monitor_port", translate("Mirror monitor port"))

			local pt
			for pt = 0, num_ports - 1 do
				local name

				name = (pt == cpu_port) and translate("CPU") or translatef("Port %d", pt)

				sp:value(pt, name)
				mp:value(pt, name)
			end
		end

		-- VLAN table
		s = m:section(TypedSection, "switch_vlan", -- 以类型标签为关键字的section
			switch_title and translatef("VLANs on %q (%s)", switch_name, switch_title)
						  or translatef("VLANs on %q", switch_name))

		s.template = "cbi/tblsection"
		s.addremove = true
		s.anonymous = true

		-- Filter by switch
		-- 过滤一些不想显示的section
		-- 返回 nil      过滤掉
		-- 返回section   正常显示
		s.filter = function(self, section)
		-- UCI get  Map.get(self, section, option) -> section <-> switch_vlan option <-> device 获得对应setion中某个字段的值
			local device = m:get(section, "device") 
			return (device and device == switch_name)
		end

		-- Override cfgsections callback to enforce row ordering by vlan id.
		-- 重载函数只是对以前的输出几个排个序
		s.cfgsections = function(self)
			local osections = TypedSection.cfgsections(self)
			local sections = { }
			local section

			for _, section in luci.util.spairs(
				osections,
				function(a, b)
					return (tonumber(m:get(osections[a], has_vlan4k or "vlan")) or 9999)
						<  (tonumber(m:get(osections[b], has_vlan4k or "vlan")) or 9999)
				end
			) do
				sections[#sections+1] = section
			end

			return sections
		end

		-- When creating a new vlan, preset it with the highest found vid + 1.
		s.create = function(self, section, origin)
			-- Filter by switch
			if m:get(origin, "device") ~= switch_name then
				return
			end
-- step 获取
			local sid = TypedSection.create(self, section) -- 返回应该是字符串类型，即section类型的名称

			local max_nr = 0
			local max_id = 0
-- step 遍历，求最大值
			m.uci:foreach("network", "switch_vlan",
				function(s)
					if s.device == switch_name then
						local nr = tonumber(s.vlan)
						local id = has_vlan4k and tonumber(s[has_vlan4k])
						if nr ~= nil and nr > max_nr then max_nr = nr end
						if id ~= nil and id > max_id then max_id = id end
					end
				end)
-- step 设置最大值
			m:set(sid, "device", switch_name)
			m:set(sid, "vlan", max_nr + 1)

			if has_vlan4k then
				m:set(sid, has_vlan4k, max_id + 1)
			end
-- step 返回最大值
			return sid
		end


		local port_opts = { }
		local untagged  = { }

		-- Parse current tagging state from the "ports" option.
		local portvalue = function(self, section)
			local pt
			for pt in (m:get(section, "ports") or ""):gmatch("%w+") do
				local pc, tu = pt:match("^(%d+)([tu]*)")
				if pc == self.option then return (#tu > 0) and tu or "u" end
			end
			return ""
		end

		-- Validate port tagging. Ensure that a port is only untagged once,
		-- bail out if not.
		local portvalidate = function(self, value, section)
			-- ensure that the ports appears untagged only once
			if value == "u" then
				if not untagged[self.option] then
					untagged[self.option] = true
				elseif min_vid > 0 or tonumber(self.option) ~= cpu_port then -- enable multiple untagged cpu ports due to weird broadcom default setup
					return nil,
						translatef("Port %d is untagged in multiple VLANs!", tonumber(self.option) + 1)
				end
			end
			return value
		end

        -- value 显示一个可输入值的编辑框
		local vid = s:option(Value, has_vlan4k or "vlan", "VLAN ID", "<div id='portstatus-%s'></div>" % switch_name)
		local mx_vid = has_vlan4k and 4094 or (num_vlans - 1)

		vid.rmempty = false
		vid.forcewrite = true
		vid.vlan_used = { }
		vid.datatype = "and(uinteger,range("..min_vid..","..mx_vid.."))"

		-- Validate user provided VLAN ID, make sure its within the bounds
		-- allowed by the switch.
		vid.validate = function(self, value, section)
			local v = tonumber(value)
			local m = has_vlan4k and 4094 or (num_vlans - 1)
			if v ~= nil and v >= min_vid and v <= m then
				if not self.vlan_used[v] then
					self.vlan_used[v] = true
					return value
				else
					return nil,
						translatef("Invalid VLAN ID given! Only unique IDs are allowed")
				end
			else
				return nil,
					translatef("Invalid VLAN ID given! Only IDs between %d and %d are allowed.", min_vid, m)
			end
		end

		-- When writing the "vid" or "vlan" option, serialize the port states
		-- as well and write them as "ports" option to uci.
		vid.write = function(self, section, value)
			local o
			local p = { }

			for _, o in ipairs(port_opts) do
				local v = o:formvalue(section)
				if v == "t" then
					p[#p+1] = o.option .. v
				elseif v == "u" then
					p[#p+1] = o.option
				end
			end

			if enable_vlan4k then
				m:set(sid, "enable_vlan4k", "1")
			end

			m:set(section, "ports", table.concat(p, " "))
			return Value.write(self, section, value)
		end

		-- Fallback to "vlan" option if "vid" option is supported but unset.
		vid.cfgvalue = function(self, section)
			return m:get(section, has_vlan4k or "vlan")
				or m:get(section, "vlan")
		end

		-- Build per-port off/untagged/tagged choice lists.
		local pt
		for pt = 0, num_ports - 1 do
			local title
			if pt == cpu_port then
				title = translate("CPU")
			else
				title = translatef("Port %d", pt)
			end

			local po = s:option(ListValue, tostring(pt), title) -- ListValue 枚举类型

			po:value("",  translate("off"))
			po:value("u", translate("untagged"))
			po:value("t", translate("tagged"))

			po.cfgvalue = portvalue
			po.validate = portvalidate
			po.write    = function() end

			port_opts[#port_opts+1] = po
		end

		switches[#switches+1] = switch_name
	end
)

-- Switch status template
s = m:section(SimpleSection)
s.template = "admin_network/switch_status"
s.switches = switches

return m

