-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Licensed to the public under the Apache License 2.0.

local io     = require "io"
local os     = require "os"
local table  = require "table"
local nixio  = require "nixio"
local fs     = require "nixio.fs"
local uci    = require "luci.model.uci"

local luci  = {}
luci.util   = require "luci.util"
luci.ip     = require "luci.ip"

local tonumber, ipairs, pairs, pcall, type, next, setmetatable, require, select =
	tonumber, ipairs, pairs, pcall, type, next, setmetatable, require, select


module "luci.sys"

-- 返回状态码
-- + Execute a given shell command and return the error code
-- # ...: Command to call
-- $ Error code of the command
function call(...)
	return os.execute(...) / 256
end

-- + Execute a given shell command and capture its standard output
-- # command: Command to call
-- $ String containg the return the output of the command
exec = luci.util.exec

-- lua -l luci.sys -e 'for k, v in pairs(luci.sys.mounts()) do for n, m in pairs(v) do print(n, "\t", m) end  end'
-- + Retrieve information about currently mounted file systems.
-- # 
-- $ Table containing mount information
function mounts()
	local data = {}
	local k = {"fs", "blocks", "used", "available", "percent", "mountpoint"}
	local ps = luci.util.execi("df")

	if not ps then
		return
	else
		ps()
	end

	for line in ps do
		local row = {}

		local j = 1
		for value in line:gmatch("[^%s]+") do
			row[k[j]] = value
			j = j + 1
		end

		if row[k[1]] then

			-- this is a rather ugly workaround to cope with wrapped lines in
			-- the df output:
			--
			--	/dev/scsi/host0/bus0/target0/lun0/part3
			--                   114382024  93566472  15005244  86% /mnt/usb
			--

			if not row[k[2]] then
				j = 2
				line = ps()
				for value in line:gmatch("[^%s]+") do
					row[k[j]] = value
					j = j + 1
				end
			end

			table.insert(data, row)
		end
	end

	return data
end

-- containing the whole environment is returned otherwise this function returns
-- the corresponding string value for the given name or nil if no such variable
-- exists.
-- + Retrieve environment variables.
-- # var: Name of the environment variable to retrieve (optional)
-- $ String containg the value of the specified variable
-- $ Table containing all variables if no variable name is given
getenv = nixio.getenv

-- lua -l luci.sys -e 'print(luci.sys.hostname()) '
-- + Get or set the current hostname.
-- # String: containing a new hostname to set (optional)
-- $ String containing the system hostname
function hostname(newname)
	if type(newname) == "string" and #newname > 0 then
		fs.writefile( "/proc/sys/kernel/hostname", newname )
		return newname
	else
		return nixio.uname().nodename
	end
end

-- wget
-- sys.httpget(url)
-- sys.httpget("http://127.0.0.1:%d/" % (port or 8200), true)
-- + Returns the contents of a documented referred by an URL.
-- # url: The URL to retrieve\
-- # stream: Return a stream instead of a buffer
-- # target: Directly write to target file name
-- $ String containing the contents of given the URL
function httpget(url, stream, target)
	if not target then
		local source = stream and io.popen or luci.util.exec
		return source("wget -qO- '"..url:gsub("'", "").."'")
	else
		return os.execute("wget -qO '%s' '%s'" %
			{target:gsub("'", ""), url:gsub("'", "")})
	end
end

-- reboot
-- + Initiate a system reboot.
-- $ Return value of os.execute()
function reboot()
	return os.execute("reboot >/dev/null 2>&1")
end

-- logread
-- lua -l luci.sys -e 'print(luci.sys.syslog()) '
function syslog()
	return luci.util.exec("logread")
end

-- dmesg
-- lua -l luci.sys -e 'print(luci.sys.dmesg()) '
-- + Retrieves the output of the "logread" command.
-- $ String containing the current log buffer
function dmesg()
	return luci.util.exec("dmesg")
end

-- 生成随机数
-- lua -l luci.sys -e 'print(luci.sys.uniqueid(10)) '
-- + Generates a random id with specified length.
-- # bytes: Number of bytes for the unique id
-- $ String containing hex encoded id
function uniqueid(bytes)
	local rand = fs.readfile("/dev/urandom", bytes)
	return rand and nixio.bin.hexlify(rand)
end

-- 负载
-- lua -l luci.sys -e 'print(luci.sys.uptime()) '
-- + Returns the current system uptime stats.
-- $ String containing total uptime in seconds
function uptime()
	return nixio.sysinfo().uptime
end


-- luci.util.dumptable(luci.sys.net.deviceinfo())  -- Returns the current arp-table entries as two-dimensional table.
-- luci.util.dumptable(luci.sys.net.arptable())    -- Table containing all current interface names and their information
-- luci.util.dumptable(luci.sys.net.devices ())    -- Table containing all current interface names

net = {} -- 这里net只是个函数操作集合而已

local function _nethints(what, callback)
	local _, k, e, mac, ip, name
	local cur = uci.cursor()
	local ifn = { }
	local hosts = { }
	local lookup = { }

	local function _add(i, ...)
		local k = select(i, ...)
		if k then
			if not hosts[k] then hosts[k] = { } end
			hosts[k][1] = select(1, ...) or hosts[k][1]
			hosts[k][2] = select(2, ...) or hosts[k][2]
			hosts[k][3] = select(3, ...) or hosts[k][3]
			hosts[k][4] = select(4, ...) or hosts[k][4]
		end
	end

	luci.ip.neighbors(nil, function(neigh) -- ip 也是个动态库文件
		if neigh.mac and neigh.family == 4 then
			_add(what, neigh.mac:upper(), neigh.dest:string(), nil, nil)
		elseif neigh.mac and neigh.family == 6 then
			_add(what, neigh.mac:upper(), nil, neigh.dest:string(), nil)
		end
	end)

	if fs.access("/etc/ethers") then
		for e in io.lines("/etc/ethers") do
			mac, ip = e:match("^([a-f0-9]%S+) (%S+)")
			if mac and ip then
				_add(what, mac:upper(), ip, nil, nil)
			end
		end
	end

	cur:foreach("dhcp", "dnsmasq",
		function(s)
			if s.leasefile and fs.access(s.leasefile) then
				for e in io.lines(s.leasefile) do
					mac, ip, name = e:match("^%d+ (%S+) (%S+) (%S+)")
					if mac and ip then
						_add(what, mac:upper(), ip, nil, name ~= "*" and name)
					end
				end
			end
		end
	)

	cur:foreach("dhcp", "host",
		function(s)
			for mac in luci.util.imatch(s.mac) do
				_add(what, mac:upper(), s.ip, nil, s.name)
			end
		end)

	for _, e in ipairs(nixio.getifaddrs()) do
		if e.name ~= "lo" then
			ifn[e.name] = ifn[e.name] or { }
			if e.family == "packet" and e.addr and #e.addr == 17 then
				ifn[e.name][1] = e.addr:upper()
			elseif e.family == "inet" then
				ifn[e.name][2] = e.addr
			elseif e.family == "inet6" then
				ifn[e.name][3] = e.addr
			end
		end
	end

	for _, e in pairs(ifn) do
		if e[what] and (e[2] or e[3]) then
			_add(what, e[1], e[2], e[3], e[4])
		end
	end

	for _, e in pairs(hosts) do
		lookup[#lookup+1] = (what > 1) and e[what] or (e[2] or e[3])
	end

	if #lookup > 0 then
		lookup = luci.util.ubus("network.rrdns", "lookup", {
			addrs   = lookup,
			timeout = 250,
			limit   = 1000
		}) or { }
	end

	for _, e in luci.util.kspairs(hosts) do
		callback(e[1], e[2], e[3], lookup[e[2]] or lookup[e[3]] or e[4])
	end
end

--          Each entry contains the values in the following order:
--          [ "mac", "name" ]
-- lua -l luci.sys -e 'mac=luci.sys.net.mac_hints(nil) for k,v in pairs(mac) do for i,j in pairs(v) do print(k,i,j) end  end '
-- + Returns a two-dimensional table of mac address hints.
-- $ Table of table containing known hosts from various sources. Each entry contains the values in the following order: [ "mac", "name" ]
function net.mac_hints(callback)
	if callback then
		_nethints(1, function(mac, v4, v6, name)
			name = name or v4
			if name and name ~= mac then
				callback(mac, name or v4)
			end
		end)
	else
		local rv = { }
		_nethints(1, function(mac, v4, v6, name)
			name = name or v4
			if name and name ~= mac then
				rv[#rv+1] = { mac, name or v4 }
			end
		end)
		return rv
	end
end

--          Each entry contains the values in the following order:
--          [ "ip", "name" ]
-- lua -l luci.sys -e 'mac=luci.sys.net.ipv4_hints(nil) for k,v in pairs(mac) do for i,j in pairs(v) do print(k,i,j) end  end '
-- + Returns a two-dimensional table of IPv4 address hints.
-- $ Table of table containing known hosts from various sources. Each entry contains the values in the following order: [ "ip", "name" ]
function net.ipv4_hints(callback)
	if callback then
		_nethints(2, function(mac, v4, v6, name)
			name = name or mac
			if name and name ~= v4 then
				callback(v4, name)
			end
		end)
	else
		local rv = { }
		_nethints(2, function(mac, v4, v6, name)
			name = name or mac
			if name and name ~= v4 then
				rv[#rv+1] = { v4, name }
			end
		end)
		return rv
	end
end

--          Each entry contains the values in the following order:
--          [ "ip", "name" ]
-- lua -l luci.sys -e 'mac=luci.sys.net.ipv6_hints(nil) for k,v in pairs(mac) do for i,j in pairs(v) do print(k,i,j) end  end '
-- + Returns a two-dimensional table of IPv4 address hints.
-- $ Table of table containing known hosts from various sources. Each entry contains the values in the following order: [ "ip", "name" ]
function net.ipv6_hints(callback)
	if callback then
		_nethints(3, function(mac, v4, v6, name)
			name = name or mac
			if name and name ~= v6 then
				callback(v6, name)
			end
		end)
	else
		local rv = { }
		_nethints(3, function(mac, v4, v6, name)
			name = name or mac
			if name and name ~= v6 then
				rv[#rv+1] = { v6, name }
			end
		end)
		return rv
	end
end

-- + Returns a two-dimensional table of host hints.
-- # Table of table containing known hosts from various sources, indexed by mac address. Each subtable contains at least one of the fields "name", "ipv4" or "ipv6".
function net.host_hints(callback)
	if callback then
		_nethints(1, function(mac, v4, v6, name)
			if mac and mac ~= "00:00:00:00:00:00" and (v4 or v6 or name) then
				callback(mac, v4, v6, name)
			end
		end)
	else
		local rv = { }
		_nethints(1, function(mac, v4, v6, name)
			if mac and mac ~= "00:00:00:00:00:00" and (v4 or v6 or name) then
				local e = { }
				if v4   then e.ipv4 = v4   end
				if v6   then e.ipv6 = v6   end
				if name then e.name = name end
				rv[mac] = e
			end
		end)
		return rv
	end
end

-- + Returns conntrack information
-- $ Table with the currently tracked IP connections
function net.conntrack(callback)
	local ok, nfct = pcall(io.lines, "/proc/net/nf_conntrack")
	if not ok or not nfct then
		return nil
	end

	local line, connt = nil, (not callback) and { }
	for line in nfct do
		local fam, l3, l4, timeout, tuples =
			line:match("^(ipv[46]) +(%d+) +%S+ +(%d+) +(%d+) +(.+)$")

		if fam and l3 and l4 and timeout and not tuples:match("^TIME_WAIT ") then
			l4 = nixio.getprotobynumber(l4)

			local entry = {
				bytes = 0,
				packets = 0,
				layer3 = fam,
				layer4 = l4 and l4.name or "unknown",
				timeout = tonumber(timeout, 10)
			}

			local key, val
			for key, val in tuples:gmatch("(%w+)=(%S+)") do
				if key == "bytes" or key == "packets" then
					entry[key] = entry[key] + tonumber(val, 10)
				elseif key == "src" or key == "dst" then
					if entry[key] == nil then
						entry[key] = luci.ip.new(val):string()
					end
				elseif key == "sport" or key == "dport" then
					if entry[key] == nil then
						entry[key] = val
					end
				elseif val then
					entry[key] = val
				end
			end

			if callback then
				callback(entry)
			else
				connt[#connt+1] = entry
			end
		end
	end

	return callback and true or connt
end

function net.devices()
	local devs = {}
	for k, v in ipairs(nixio.getifaddrs()) do
		if v.family == "packet" then
			devs[#devs+1] = v.name
		end
	end
	return devs
end


process = {}

-- luci.util.dumptable(luci.sys.process.info())
-- luci.util.perror(luci.sys.process.info('uid'))
-- luci.util.perror(luci.sys.process.info('gid'))
-- + Get the current process id.
-- $ Number containing the current pid
function process.info(key)
	local s = {uid = nixio.getuid(), gid = nixio.getgid()}
	return not key and s or s[key]
end

-- luci.util.dumptable(luci.sys.process.list())
-- + Retrieve information about currently running processes.
-- $ Table containing process information
function process.list()
	local data = {}
	local k
	local ps = luci.util.execi("/bin/busybox top -bn1")

	if not ps then
		return
	end

	for line in ps do
		local pid, ppid, user, stat, vsz, mem, cpu, cmd = line:match(
			"^ *(%d+) +(%d+) +(%S.-%S) +([RSDZTW][W ][<N ]) +(%d+) +(%d+%%) +(%d+%%) +(.+)"
		)

		local idx = tonumber(pid)
		if idx then
			data[idx] = {
				['PID']     = pid,
				['PPID']    = ppid,
				['USER']    = user,
				['STAT']    = stat,
				['VSZ']     = vsz,
				['%MEM']    = mem,
				['%CPU']    = cpu,
				['COMMAND'] = cmd
			}
		end
	end

	return data
end

-- + Set the gid of a process identified by given pid.
-- # gid: Number containing the Unix group id
-- $ Boolean indicating successful operation
-- $ String containing the error message if failed
-- $ Number containing the error code if failed
function process.setgroup(gid)
	return nixio.setgid(gid)
end

-- + Set the uid of a process identified by given pid.
-- # uid: Number containing the Unix user id
-- $ Boolean indicating successful operation
-- $ String containing the error message if failed
-- $ Number containing the error code if failed
function process.setuser(uid)
	return nixio.setuid(uid)
end

-- + Send a signal to a process identified by given pid.
-- # pid: Number containing the process id
-- # sig: Signal to send (default: 15 [SIGTERM])
-- $ Boolean indicating successful operation
-- $ Number containing the error code if failed
process.signal = nixio.kill


user = {}

--				{ "uid", "gid", "name", "passwd", "dir", "shell", "gecos" }
-- luci.util.dumptable(luci.sys.user.getuser('root'))
-- luci.util.dumptable(luci.sys.user.getuser('ftp'))
-- + Retrieve user informations for given uid.
-- # uid: Number containing the Unix user id
-- $ Table containing the following fields: { "uid", "gid", "name", "passwd", "dir", "shell", "gecos" }
user.getuser = nixio.getpw

-- luci.util.perror(luci.sys.user.getpasswd('root'))
-- + Retrieve the current user password hash.
-- # username: String containing the username to retrieve the password for
-- $ String containing the hash or nil if no password is set.
-- $ Password database entry
function user.getpasswd(username)
	local pwe = nixio.getsp and nixio.getsp(username) or nixio.getpw(username)
	local pwh = pwe and (pwe.pwdp or pwe.passwd)
	if not pwh or #pwh < 1 or pwh == "!" or pwh == "x" then
		return nil, pwe
	else
		return pwh, pwe
	end
end

-- luci.util.perror(luci.sys.user.checkpasswd('root','123456'))
-- + Test whether given string matches the password of a given system user.
-- # username: String containing the Unix user name
-- # pass: String containing the password to compare
-- $ Boolean indicating wheather the passwords are equal
function user.checkpasswd(username, pass)
	local pwh, pwe = user.getpasswd(username)
	if pwe then
		return (pwh == nil or nixio.crypt(pass, pwh) == pwh)
	end
	return false
end

-- + Change the password of given user.
-- # username: String containing the Unix user name
-- # password: String containing the password to compare
-- $ Number containing 0 on success and >= 1 on error
function user.setpasswd(username, password)
	if password then
--		password = password:gsub("'", [['"'"']])
	end

	if username then
--		username = username:gsub("'", [['"'"']])
	end

	return os.execute(
		"(echo '" .. password .. "'; sleep 1; echo '" .. password .. "') | " ..
		"passwd '" .. username .. "' >/dev/null 2>&1"
	)
end


wifi = {}

function wifi.getiwinfo(ifname)
	local stat, iwinfo = pcall(require, "iwinfo")

	if ifname then
		local d, n = ifname:match("^(%w+)%.network(%d+)")
		local wstate = luci.util.ubus("network.wireless", "status") or { }

		d = d or ifname
		n = n and tonumber(n) or 1

		if type(wstate[d]) == "table" and
		   type(wstate[d].interfaces) == "table" and
		   type(wstate[d].interfaces[n]) == "table" and
		   type(wstate[d].interfaces[n].ifname) == "string"
		then
			ifname = wstate[d].interfaces[n].ifname
		else
			ifname = d
		end

		local t = stat and iwinfo.type(ifname)
		local x = t and iwinfo[t] or { }
		return setmetatable({}, {
			__index = function(t, k)
				if k == "ifname" then
					return ifname
				elseif x[k] then
					return x[k](ifname)
				end
			end
		})
	end
end


init = {}
init.dir = "/etc/init.d/"

-- print(luci.util.dumptable(luci.sys.init.names()))
-- + Get the names of all installed init scripts
-- $ Table containing the names of all inistalled init scripts
function init.names()
	local names = { }
	for name in fs.glob(init.dir.."*") do
		names[#names+1] = fs.basename(name)
	end
	return names
end

-- + Get the index of he given init script
-- # name: Name of the init script
-- $ Numeric index value
function init.index(name)
	if fs.access(init.dir..name) then
		return call("env -i sh -c 'source %s%s enabled; exit ${START:-255}' >/dev/null"
			%{ init.dir, name })
	end
end

local function init_action(action, name)
	if fs.access(init.dir..name) then
		return call("env -i %s%s %s >/dev/null" %{ init.dir, name, action })
	end
end

-- + Test whether the given init script is enabled
-- # name: Name of the init script
-- $ Boolean indicating whether init is enabled
function init.enabled(name)
	return (init_action("enabled", name) == 0)
end

-- + Enable the given init script
-- # name: Name of the init script
-- $ Boolean indicating success
function init.enable(name)
	return (init_action("enable", name) == 1)
end

-- + Disable the given init script
-- # name: Name of the init script
-- $ Boolean indicating success
function init.disable(name)
	return (init_action("disable", name) == 0)
end

-- + Start the given init script
-- # name: Name of the init script
-- $ Boolean indicating success
function init.start(name)
	return (init_action("start", name) == 0)
end

-- + Stop the given init script
-- # name: Name of the init script
-- $ Boolean indicating success
function init.stop(name)
	return (init_action("stop", name) == 0)
end
