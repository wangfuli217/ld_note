--[[

Iptables parser and query library
(c) 2008-2009 Jo-Philipp Wich <jow@openwrt.org>
(c) 2008-2009 Steven Barth <steven@midlink.org>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

$Id$

]]--

local luci  = {}
luci.util   = require "luci.util"
luci.sys    = require "luci.sys"
luci.ip     = require "luci.ip"

local pcall = pcall
local io = require "io"
local tonumber, ipairs, table = tonumber, ipairs, table

module("luci.sys.iptparser")

IptParser = luci.util.class() -- 对class函数进行调用，这样IptParser就是一个table值，

-- luci.util.dumptable(ipt4)
-- luci.util.dumptable(ipt4._family)
-- luci.util.dumptable(ipt4._rules)
-- luci.util.dumptable(ipt4._chains)
-- luci.util.dumptable(ipt4._tables)
-- + Create a new iptables parser object.
-- # family: Number specifying the address family. 4 for IPv4, 6 for IPv6
-- $ IptParser instance
function IptParser.__init__( self, family ) -- IptParser 有 成员 __init__
	self._family = (tonumber(family) == 6) and 6 or 4
	self._rules  = { }
	self._chains = { }
	self._tables = { }

	local t = self._tables
	local s = self:_supported_tables(self._family)

	if s.filter then t[#t+1] = "filter" end
	if s.nat    then t[#t+1] = "nat"    end
	if s.mangle then t[#t+1] = "mangle" end
	if s.raw    then t[#t+1] = "raw"    end

	if self._family == 4 then
		self._nulladdr = "0.0.0.0/0"
		self._command  = "iptables -t %s --line-numbers -nxvL"
	else
		self._nulladdr = "::/0"
		self._command  = "ip6tables -t %s --line-numbers -nxvL"
	end

	self:_parse_rules()
end

function IptParser._supported_tables( self, family )
	local tables = { }
	local ok, lines = pcall(io.lines,
		(family == 6) and "/proc/net/ip6_tables_names"
		               or "/proc/net/ip_tables_names")

	if ok and lines then
		local line
		for line in lines do
			tables[line] = true
		end
	end

	return tables
end

-- search criteria as only argument. If args is nil or an empty table then all
-- rules will be returned.
--
-- The following keys in the args table are recognized:
-- <ul>
--  <li> table		 - Match rules that are located within the given table
--  <li> chain		 - Match rules that are located within the given chain
--  <li> target		 - Match rules with the given target
--  <li> protocol	 - Match rules that match the given protocol, rules with
-- 						protocol "all" are always matched
--  <li> source		 - Match rules with the given source, rules with source
-- 						"0.0.0.0/0" (::/0) are always matched
--  <li> destination - Match rules with the given destination, rules with
-- 						destination "0.0.0.0/0" (::/0) are always matched
--  <li> inputif	 - Match rules with the given input interface, rules
-- 						with input	interface "*" (=all) are always matched
--  <li> outputif	 - Match rules with the given output interface, rules
-- 						with output	interface "*" (=all) are always matched
--  <li> flags		 - Match rules that match the given flags, current
-- 						supported values are "-f" (--fragment)
--						and "!f" (! --fragment)
--  <li> options	 - Match rules containing all given options
-- </ul>
-- The return value is a list of tables representing the matched rules.
-- Each rule table contains the following fields:
-- <ul>
--  <li> index		 - The index number of the rule
--  <li> table		 - The table where the rule is located, can be one
--	 					of "filter", "nat" or "mangle"
--  <li> chain		 - The chain where the rule is located, e.g. "INPUT"
-- 						or "postrouting_wan"
--  <li> target		 - The rule target, e.g. "REJECT" or "DROP"
--  <li> protocol		The matching protocols, e.g. "all" or "tcp"
--  <li> flags		 - Special rule options ("--", "-f" or "!f")
--  <li> inputif	 - Input interface of the rule, e.g. "eth0.0"
-- 						or "*" for all interfaces
--  <li> outputif	 - Output interface of the rule,e.g. "eth0.0"
-- 						or "*" for all interfaces
--  <li> source		 - The source ip range, e.g. "0.0.0.0/0" (::/0)
--  <li> destination - The destination ip range, e.g. "0.0.0.0/0" (::/0)
--  <li> options	 - A list of specific options of the rule,
-- 						e.g. { "reject-with", "tcp-reset" }
--  <li> packets	 - The number of packets matched by the rule
--  <li> bytes		 - The number of total bytes matched by the rule
-- </ul>
-- Example:
-- <pre>
-- ip = luci.sys.iptparser.IptParser()
-- result = ip.find( {
-- 	target="REJECT",
-- 	protocol="tcp",
-- 	options={ "reject-with", "tcp-reset" }
-- } )
-- </pre>
-- This will match all rules with target "-j REJECT",
-- protocol "-p tcp" (or "-p all")
-- and the option "--reject-with tcp-reset".
function IptParser.find( self, args )  -- IptParser 有 成员 find

	local args = args or { }
	local rv   = { }

	args.source      = args.source      and self:_parse_addr(args.source)
	args.destination = args.destination and self:_parse_addr(args.destination)

	for i, rule in ipairs(self._rules) do
		local match = true

		-- match table
		if not ( not args.table or args.table:lower() == rule.table ) then
			match = false
		end

		-- match chain
		if not ( match == true and (
			not args.chain or args.chain == rule.chain
		) ) then
			match = false
		end

		-- match target
		if not ( match == true and (
			not args.target or args.target == rule.target
		) ) then
			match = false
		end

		-- match protocol
		if not ( match == true and (
			not args.protocol or rule.protocol == "all" or
			args.protocol:lower() == rule.protocol
		) ) then
			match = false
		end

		-- match source
		if not ( match == true and (
			not args.source or rule.source == self._nulladdr or
			self:_parse_addr(rule.source):contains(args.source)
		) ) then
			match = false
		end

		-- match destination
		if not ( match == true and (
			not args.destination or rule.destination == self._nulladdr or
			self:_parse_addr(rule.destination):contains(args.destination)
		) ) then
			match = false
		end

		-- match input interface
		if not ( match == true and (
			not args.inputif or rule.inputif == "*" or
			args.inputif == rule.inputif
		) ) then
			match = false
		end

		-- match output interface
		if not ( match == true and (
			not args.outputif or rule.outputif == "*" or
			args.outputif == rule.outputif
		) ) then
			match = false
		end

		-- match flags (the "opt" column)
		if not ( match == true and (
			not args.flags or rule.flags == args.flags
		) ) then
			match = false
		end

		-- match specific options
		if not ( match == true and (
			not args.options or
			self:_match_options( rule.options, args.options )
		) ) then
			match = false
		end

		-- insert match
		if match == true then
			rv[#rv+1] = rule
		end
	end

	return rv
end


-- through external commands.
-- + Rebuild the internal lookup table, for example when rules have changed through external commands.
-- nothing
function IptParser.resync( self )  -- IptParser 有 成员 resync
	self._rules = { }
	self._chain = nil
	self:_parse_rules()
end

-- luci.util.dumptable(ipt4:tables())
-- + Find the names of all tables.
-- $ Table of table names.
function IptParser.tables( self ) -- IptParser 有 成员 tables
	return self._tables
end

-- luci.util.dumptable(ipt4:chains("filter"))
-- luci.util.dumptable(ipt4:chains("nat"))
-- luci.util.dumptable(ipt4:chains("mangle"))
-- luci.util.dumptable(ipt4:chains("raw"))
-- + Find the names of all chains within the given table name.
-- # table: String containing the table name
-- $ Table of chain names in the order they occur.
function IptParser.chains( self, table )  -- IptParser 有 成员 chains
	local lookup = { }
	local chains = { }
	for _, r in ipairs(self:find({table=table})) do
		if not lookup[r.chain] then
			lookup[r.chain]   = true
			chains[#chains+1] = r.chain
		end
	end
	return chains
end

-- luci.util.dumptable(ipt4:chain("raw", 'PREROUTING'))
-- luci.util.dumptable(ipt4:chain("mangle", 'PREROUTING'))
-- luci.util.dumptable(ipt4:chain("nat", 'PREROUTING'))
-- luci.util.dumptable(ipt4:chain("filter", 'INPUT'))
--				and "rules". The "rules" field is a table of rule tables.
-- + Return the given firewall chain within the given table name.
-- # table: String containing the table name
-- # chain: String containing the chain name
-- $ Table containing the fields "policy", "packets", "bytes" and "rules". The "rules" field is a table of rule tables.
function IptParser.chain( self, table, chain )
	return self._chains[table:lower()] and self._chains[table:lower()][chain]
end

-- 不可用
-- + Test whether the given target points to a custom chain.
-- # target: String containing the target action
-- $ Boolean indicating whether target is a custom chain.
function IptParser.is_custom_target( self, target ) -- IptParser 有 成员 is_custom_target
	for _, r in ipairs(self._rules) do
		if r.chain == target then
			return true
		end
	end
	return false
end


-- [internal] Parse address according to family.
function IptParser._parse_addr( self, addr )  -- IptParser 有 成员 _parse_addr
	if self._family == 4 then
		return luci.ip.IPv4(addr)
	else
		return luci.ip.IPv6(addr)
	end
end

-- [internal] Parse iptables output from all tables.
function IptParser._parse_rules( self )

	for i, tbl in ipairs(self._tables) do

		self._chains[tbl] = { }

		for i, rule in ipairs(luci.util.execl(self._command % tbl)) do

			if rule:find( "^Chain " ) == 1 then

				local crefs
				local cname, cpol, cpkt, cbytes = rule:match(
					"^Chain ([^%s]*) %(policy (%w+) " ..
					"(%d+) packets, (%d+) bytes%)"
				)

				if not cname then
					cname, crefs = rule:match(
						"^Chain ([^%s]*) %((%d+) references%)"
					)
				end

				self._chain = cname
				self._chains[tbl][cname] = {
					policy     = cpol,
					packets    = tonumber(cpkt or 0),
					bytes      = tonumber(cbytes or 0),
					references = tonumber(crefs or 0),
					rules      = { }
				}

			else
				if rule:find("%d") == 1 then

					local rule_parts   = luci.util.split( rule, "%s+", nil, true )
					local rule_details = { }

					-- cope with rules that have no target assigned
					if rule:match("^%d+%s+%d+%s+%d+%s%s") then
						table.insert(rule_parts, 4, nil)
					end

					-- ip6tables opt column is usually zero-width
					if self._family == 6 then
						table.insert(rule_parts, 6, "--")
					end

					rule_details["table"]       = tbl
					rule_details["chain"]       = self._chain
					rule_details["index"]       = tonumber(rule_parts[1])
					rule_details["packets"]     = tonumber(rule_parts[2])
					rule_details["bytes"]       = tonumber(rule_parts[3])
					rule_details["target"]      = rule_parts[4]
					rule_details["protocol"]    = rule_parts[5]
					rule_details["flags"]       = rule_parts[6]
					rule_details["inputif"]     = rule_parts[7]
					rule_details["outputif"]    = rule_parts[8]
					rule_details["source"]      = rule_parts[9]
					rule_details["destination"] = rule_parts[10]
					rule_details["options"]     = { }

					for i = 11, #rule_parts  do
						if #rule_parts[i] > 0 then
							rule_details["options"][i-10] = rule_parts[i]
						end
					end

					self._rules[#self._rules+1] = rule_details

					self._chains[tbl][self._chain].rules[
						#self._chains[tbl][self._chain].rules + 1
					] = rule_details
				end
			end
		end
	end

	self._chain = nil
end


-- [internal] Return true if optlist1 contains all elements of optlist 2.
--            Return false in all other cases.
function IptParser._match_options( self, o1, o2 )

	-- construct a hashtable of first options list to speed up lookups
	local oh = { }
	for i, opt in ipairs( o1 ) do oh[opt] = true end

	-- iterate over second options list
	-- each string in o2 must be also present in o1
	-- if o2 contains a string which is not found in o1 then return false
	for i, opt in ipairs( o2 ) do
		if not oh[opt] then
			return false
		end
	end

	return true
end
