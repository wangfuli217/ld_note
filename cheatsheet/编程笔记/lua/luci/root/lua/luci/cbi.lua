-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Licensed to the public under the Apache License 2.0.

module("luci.cbi", package.seeall)

require("luci.template")
local util = require("luci.util")
require("luci.http")


--local event      = require "luci.sys.event"
local fs         = require("nixio.fs")
local uci        = require("luci.model.uci")
local datatypes  = require("luci.cbi.datatypes")
local dispatcher = require("luci.dispatcher")
local class      = util.class
local instanceof = util.instanceof

FORM_NODATA  =  0 -- ����web��form��û��"cbi.submit"
FORM_PROCEED =  0 -- FORM_PROCEED =  1 ����web������δ��ȡ���
FORM_VALID   =  1 -- �������� ��invalid marked proceed, and has not changed.
FORM_DONE	 =  1 -- ����web��form��û�� "cbi.cancel" ���� "on_cancel" hook function����true
FORM_INVALID = -1 -- ����web��form��û�� save ���� ���� section|option ����һ��error
FORM_CHANGED =  2 -- formvalue �������Ѿ�д��/etc/config/uci��
FORM_SKIP    =  4 -- ����web��form���� "cbi.skip"

AUTO = true

CREATE_PREFIX = "cbi.cts."
REMOVE_PREFIX = "cbi.rts."
RESORT_PREFIX = "cbi.sts."
FEXIST_PREFIX = "cbi.cbe."

-- Loads a CBI map from given file, creating an environment and returns it
-- Delegator ʹ�ã���ǰ������û��ʹ��Delegator����ҳ���Ȳ�����
function load(cbimap, ...)
	local fs   = require "nixio.fs"
	local i18n = require "luci.i18n"
	require("luci.config")  -- ��luci.config.lua˵������ʵ��������ȫ�ֱ��� uci,ubus,luci,model,template��
	require("luci.util")    -- ����template, luci, debug, ubus ������������

	local upldir = "/etc/luci-uploads/"
	local cbidir = luci.util.libpath() .. "/model/cbi/"
	local func, err
-- �����Ӳ���filenameָ�����ļ��м������ݣ��������ݷ�װ��һ�������з���
	if fs.access(cbidir..cbimap..".lua") then
		func, err = loadfile(cbidir..cbimap..".lua")
	elseif fs.access(cbimap) then
		func, err = loadfile(cbimap)
	else
		func, err = nil, "Model '" .. cbimap .. "' not found!"
	end

	assert(func, err)

	local env = {
		translate=i18n.translate,
		translatef=i18n.translatef,
	 	arg={...} -- ����������.  arg[1] = arg[1] or "" ��ʾ����ҳ�����ʱʹ�ù��˲���
	}
-- setfenv(f, table)
-- ���ò���func��ָ������ʹ�õĵ�ǰ����������func������һ��lua����Ҳ������һ��ָ���������ò�ε�����
-- ������Ϊ1ʱ����ʾ���ڵ��ú���setfenv()�����ĺ�������������ķ���ֵ�ǲ���func��ָ���ĺ���
	setfenv(func, setmetatable(env, {__index =
		function(tbl, key)
			return rawget(tbl, key) or _M[key] or _G[key]
		end}))

	local maps       = { func() } -- �������ã�����һ������mapʵ��
	local uploads    = { }
	local has_upload = false

	for i, map in ipairs(maps) do
		if not instanceof(map, Node) then
			error("CBI map returns no valid map object!")
			return nil
		else
			map:prepare() -- ����prepare��NamedSection TypeSection AbstractValue���иú���
			if map.upload_fields then -- ֻ��FileUpload �����д˳�Ա����
				has_upload = true
				for _, field in ipairs(map.upload_fields) do
					uploads[
						field.config .. '.' ..
						(field.section.sectiontype or '1') .. '.' ..
						field.option
					] = true
				end
			end
		end
	end

	if has_upload then
		local uci = luci.model.uci.cursor()
		local prm = luci.http.context.request.message.params
		local fd, cbid

		luci.http.setfilehandler(
			function( field, chunk, eof )
				if not field then return end
				if field.name and not cbid then
					local c, s, o = field.name:gmatch(
						"cbid%.([^%.]+)%.([^%.]+)%.([^%.]+)"
					)()

					if c and s and o then
						local t = uci:get( c, s ) or s
						if uploads[c.."."..t.."."..o] then
							local path = upldir .. field.name
							fd = io.open(path, "w")
							if fd then
								cbid = field.name
								prm[cbid] = path
							end
						end
					end
				end

				if field.name == cbid and fd then
					fd:write(chunk)
				end

				if eof and fd then
					fd:close()
					fd   = nil
					cbid = nil
				end
			end
		)
	end

	return maps
end

--
-- Compile a datatype specification into a parse tree for evaluation later on
-- Ϊ�Ժ��жϹ���һ�����͹���
local cdt_cache = { }

-- ����Э��˼·: ��һ���ַ�������Э��ת��Ϊ��ṹ
-- ͨ��code(datatype)�����ö�Ӧ�Ĵ�����
-- 44 ,
-- 92 \
-- 40 (
-- 41 )
-- tb1 = compile_datatype("and(uinteger,rangelength(44,44))")
-- label=and             pos=0       i=4
-- label=uinteger        pos=0       i=9
-- label=rangelength     pos=10      i=21
-- label=44              pos=0       i=3
-- label=44              pos=4       i=6
-- util.dumptable(tb1)
-- 1       function: 0x1eaa1c0           and
-- 2       table: 0x1ee8bd0
--         1       function: 0x1e48d20   uinteger
--         2       table: 0x1ee8c20
--         3       function: 0x1e61220   rangelength
--         4       table: 0x1ee8d40
--                 1       44            value
--                 2       44            value
function compile_datatype(code)
	local i
	local pos = 0       -- start position
	local esc = false
	local depth = 0     -- byte change depth
	local stack = { }

	for i = 1, #code+1 do
		local byte = code:byte(i) or 44
		if esc then
			esc = false
		elseif byte == 92 then -- \
			esc = true
		elseif byte == 40 or byte == 44 then -- 40(  44,
			if depth <= 0 then
				if pos < i then
					local label = code:sub(pos, i-1)
						:gsub("\\(.)", "%1")
						:gsub("^%s+", "") -- trim header
						:gsub("%s+$", "") -- trim tailer

					if #label > 0 and tonumber(label) then
						stack[#stack+1] = tonumber(label)
					elseif label:match("^'.*'$") or label:match('^".*"$') then
					-- "and(uinteger,range("..min_vid..","..mx_vid.."))"
						stack[#stack+1] = label:gsub("[\"'](.*)[\"']", "%1")
					elseif type(datatypes[label]) == "function" then -- datatypes ��
						stack[#stack+1] = datatypes[label] -- ��ֵ��������ӱ�
						stack[#stack+1] = { }
					else
						error("Datatype error, bad token %q" % label)
					end
				end
				pos = i + 1
			end
			depth = depth + (byte == 40 and 1 or 0) -- 40 (
		elseif byte == 41 then -- 41 )
			depth = depth - 1
			if depth <= 0 then
				if type(stack[#stack-1]) ~= "function" then
					error("Datatype error, argument list follows non-function")
				end
				stack[#stack] = compile_datatype(code:sub(pos, i-1)) -- rescurive
				pos = i + 1
			end
		end
	end

	return stack
end

-- �ж�value�Ƿ����dt(datatype)����
function verify_datatype(dt, value)
	if dt and #dt > 0 then
		if not cdt_cache[dt] then
			local c = compile_datatype(dt)
			if c and type(c[1]) == "function" then
				cdt_cache[dt] = c
			else
				error("Datatype error, not a function expression")
			end
		end
		if cdt_cache[dt] then
			return cdt_cache[dt][1](value, unpack(cdt_cache[dt][2]))
		end
	end
	return true
end


-- Node pseudo abstract class
-- ������̣�����ӿڣ��������ݽṹ���������ݹ���ӿ�
Node = class()

-- title �ַ���
-- description �ַ���
function Node.__init__(self, title, description)
	self.children = {}
	self.title = title or ""
	self.description = description or ""
	self.template = "cbi/node"
end

-- hook helper
-- ִ���ַ�������Ϊhook�Ĺ��Ӻ��������Ӻ����Ĳ���Ϊself������
-- hook���Ӻ�������Ҫ���ഴ����ʱ�򹹽���
function Node._run_hook(self, hook)
	if type(self[hook]) == "function" then
		return self[hook](self)
	end
end

-- ִ���ַ�������Ϊ�ɱ�����Ĺ��Ӻ��������Ӻ����Ĳ���Ϊself������
-- hook���Ӻ�������Ҫ���ഴ����ʱ�򹹽���
function Node._run_hooks(self, ...)
	local f
	local r = false
	for _, f in ipairs(arg) do
		if type(self[f]) == "function" then
			self[f](self)
			r = true
		end
	end
	return r
end

-- Prepare nodes
function Node.prepare(self, ...)
	for k, child in ipairs(self.children) do
		child:prepare(...)
	end
end

-- Append child nodes
function Node.append(self, obj)
	table.insert(self.children, obj)
end

-- Parse this node and its children
-- Map��Node�����࣬��ômap.parse��ִ��Node.parse()������function Node.parse(self, ...)
-- end�ڴ˺���ִ��֮ǰ������Node.__init__(self, title, description),self.children = {}
function Node.parse(self, ...)
	for k, child in ipairs(self.children) do
		child:parse(...)
	end
end

-- Render this node
function Node.render(self, scope)
	scope = scope or {}
	scope.self = self

	luci.template.render(self.template, scope)
end

-- Render the children
function Node.render_children(self, ...)
	local k, node
	for k, node in ipairs(self.children) do
		node.last_child = (k == #self.children)
		node.index = k
		node:render(...)
	end
end


--[[
A simple template element
]]--
Template = class(Node)
-- ��cbi(SimpleForm)ʵ���ϸ���htmģ�壬��ʵ��û��title��description��ֻ��templateģ��

function Template.__init__(self, template)
-- �������ṩ������£�Ĭ�ϲ�����nil
--  Node.__init__(self, nil, nil)
	Node.__init__(self)
	self.template = template
end

-- ���Node��render������û��scope����
-- Template����Node��render����
function Template.render(self)
    -- Node���Դ���Σ�ͬʱ�������ݹ�ȥ��
    -- Template ֻ�ܽ������ݹ�ȥ
	luci.template.render(self.template, {self=self})
end

-- ���Node��parse������������readinput������
-- Node����ʵ�������ࣻTemplateʵ��parse����

-- Ȼ�����Map.formvalue(self, key) return self.readinput and luci.http.formvalue(key)
-- ����http.lua��formvalue()���Եõ�������������ݡ�
function Template.parse(self, readinput)
	self.readinput = (readinput ~= false)
	-- ���ҳ����cbi.submit�򷵻�FORM_DONE, ���򷵻�FORM_NODATA
	return Map.formvalue(self, "cbi.submit") and FORM_DONE or FORM_NODATA -- cbi.submit ��header.htm
	-- value = condition and trueval or falseval;   -- condtion == trueʱ������trueval ʧ��ʱ����falseval
	-- value = (condition and trueval) or falseval; -- and���ű�or���ߵ����ȼ�
end

-- Map��Node�����࣬��ômap.parse��ִ��Node.parse()������function Node.parse(self, ...) 
--[[
Map - A map describing a configuration file
class Map (config, title, description)
config: configuration name to be mapped, see uci documentation and the files in /etc/config
title: title shown in the UI
description: description shown in the UI

:section (sectionclass, ...)
Creates a new section
    sectionclass: a class object of the section
    additional parameters passed to the constructor of the section class
]]--
Map = class(Node)

-- Map.__init__(self, config, title, description ...)
function Map.__init__(self, config, ...)
	Node.__init__(self, ...)

	self.config = config            -- �ַ����� /etc/config�������ļ�����
	self.parsechain = {self.config} -- �����Ķ��/etc/config�������ļ�����
	self.template = "cbi/map"       -- ���� map.htm
	self.apply_on_parse = nil -- The flag that tells the map to apply all values when parsed
	self.readinput = true -- true ��ҳ���ã����򷵻�false if the map should read input or not boolean
	self.proceed = false -- children�޸ģ�˵���Ѿ�������
	self.flow = {} -- skip�� hideapplybtn�� hidesavebtn�� hideresetbtn ����ҳ����ʾ

	self.uci = uci.cursor()
	self.save = true -- �ж��ܷ��ύ

	self.changed = false -- ��children�ж��ύ�����Ƿ����仯

	-- �����ļ��������򴴽������ļ�
	local path = "%s/%s" %{ self.uci:get_confdir(), self.config }
	if fs.stat(path, "type") ~= "reg" then
		fs.writefile(path, "")
	end

	-- ������������ļ�ʧ�ܣ�
	local ok, err = self.uci:load(self.config)
	if not ok then -- ͨ������url��cbi.source�ֶΣ��õ������ļ�
		local url = dispatcher.build_url(unpack(dispatcher.context.request))
		local source = self:formvalue("cbi.source") -- ����ļ��������ݣ�
		if type(source) == "string" then -- �����������ļ���
			fs.writefile(path, source:gsub("\r\n", "\n"))
			ok, err = self.uci:load(self.config)
			if ok then
				luci.http.redirect(url)
			end
		end
		self.save = false
	end

	-- ����ʧ���򷵻ش���
	if not ok then
		self.template   = "cbi/error" -- ����htm
		self.error      = err         -- ������ʾ
		self.source     = fs.readfile(path) or "" -- ���������ļ�����
		self.pageaction = false -- 
	end
end

-- �ַ���   ҳ����Ӧ����
-- false    û�д�ҳ�淵�� readinput = false
-- nil      ҳ��û������
function Map.formvalue(self, key) -- ת luci.http.formvalue
	return self.readinput and luci.http.formvalue(key) or nil
end

-- table    �ձ�: ҳ��û�����ݣ�ҳ��������
-- false    û�д�ҳ�淵�� readinput = false
-- luci.http.formvaluetable("delzone")
-- 
function Map.formvaluetable(self, key) -- ת luci.http.formvaluetable
	return self.readinput and luci.http.formvaluetable(key) or {}
end

-- ��֪��
function Map.get_scheme(self, sectiontype, option)
	if not option then
		return self.scheme and self.scheme.sections[sectiontype]
	else
		return self.scheme and self.scheme.variables[sectiontype]
		 and self.scheme.variables[sectiontype][option]
	end
end

-- ����cbi.submit��ֵ
function Map.submitstate(self)
	return self:formvalue("cbi.submit")
end

-- Chain foreign config
-- ��map�в����ⲿ��config��Ϣ
--- m:chain("luci") �� system.lua ������/etc/config/system֮��������/etc/config/luci�����ļ�
function Map.chain(self, config)
	table.insert(self.parsechain, config)
end

-- ��ʵ�֣���û��ʵ��
function Map.state_handler(self, state)
	return state
end

-- Use optimized UCI writing
-- ����Node.parse(self, ...),(uci��Ҫ����luci�������ݽ�����ƽ̨��)
-- Map������children��parse֮���ٽ���parse,��children���޸�self.save��֪���ύ����
function Map.parse(self, readinput, ...)
	if self:formvalue("cbi.skip") then -- ����FORM_SKIP
		self.state = FORM_SKIP
	elseif not self.save then -- ������Ч
		self.state = FORM_INVALID
	elseif not self:submitstate() then -- û���ύ
		self.state = FORM_NODATA
	end

	-- Back out early to prevent unauthorized changes on the subsequent parse �Ѿ���״̬�ˣ�ֱ�ӷ��ؼ���
	if self.state ~= nil then
		return self:state_handler(self.state)
	end

	self.readinput = (readinput ~= false)
	self:_run_hooks("on_parse") 

    -- ���ε���children��parse����
	Node.parse(self, ...)
-- ���map�ı��水ť�����,����������ť����������ᴥ��uci����ĺ�������������ز�����
-- ���磺on_save, on_before_save,on_after_save, on_before_commit, on_after_commit,on_before_apply֮��
	if self.save then 
		self:_run_hooks("on_save", "on_before_save")
		for i, config in ipairs(self.parsechain) do -- ���������ļ�����  ����ʱ�洢��
			self.uci:save(config) -- Saves changes made to a config to make them committable.
		end
		self:_run_hooks("on_after_save")
		if (not self.proceed and self.flow.autoapply) or luci.http.formvalue("cbi.apply") then
			self:_run_hooks("on_before_commit")
			for i, config in ipairs(self.parsechain) do -- �ύ�����ļ����� ��/etc/configʵ�ʴ洢��
				self.uci:commit(config) -- Commit saved changes.

				-- Refresh data because commit changes section names
				self.uci:load(config)
			end
			self:_run_hooks("on_commit", "on_after_commit", "on_before_apply")
			if self.apply_on_parse then  -- ������������  
				self.uci:apply(self.parsechain) -- Applies UCI configuration changes
				self:_run_hooks("on_apply", "on_after_apply")
			else
				-- This is evaluated by the dispatcher and delegated to the
				-- template which in turn fires XHR to perform the actual
				-- apply actions.
				self.apply_needed = true -- This value is what is used by the CBI pages to actually apply the uci changes that were saved
			end

			-- Reparse sections
			Node.parse(self, true)
		end
		for i, config in ipairs(self.parsechain) do
			self.uci:unload(config)
		end
		if type(self.commit_handler) == "function" then
			self:commit_handler(self:submitstate()) -- ���map���ύ��ť�����
		end
	end

	if not self.save then -- ���û�е��save��ť
		self.state = FORM_INVALID
	elseif self.proceed then
		self.state = FORM_PROCEED
	elseif self.changed then
		self.state = FORM_CHANGED
	else
		self.state = FORM_VALID
	end
-- Used by dispatcher to redirect the user to various on_BLANK_to pages and to
-- otherwise dispatch the pages based upon the state of the map
	return self:state_handler(self.state)
end


-- ��dispatcher.lua ��_cbi�б����ã����ݸ��ֲ����ı�
function Map.render(self, ...)
	self:_run_hooks("on_init") -- �����ҳǰ����
	Node.render(self, ...)
end

-- Creates a child section �����๹��������������ʵ��
-- Map:section������һ����section,���������abstraction��ʵ������ô����Node:append()��table.insert(self.children, obj)��䡣
-- m:section(TypedSection, "global", translate("Global Settings"))
-- m:section(NamedSection, arg[1], "redirect", "")
function Map.section(self, class, ...)
	if instanceof(class, AbstractSection) then
  -- NamedSection.__init__(self, map, section, stype, ...)
  -- TypedSection.__init__(self, map, type, ...)
		local obj  = class(self, ...)
		self:append(obj)
		return obj
	else
		error("class must be a descendent of AbstractSection")
	end
end

-- UCI add Add a section to the attacked UCI config TODO check how this works
-- with chain
-- ����������� typedsection
function Map.add(self, sectiontype)
	return self.uci:add(self.config, sectiontype)
end

-- UCI set
-- ����option ��ֵ��
-- ɾ��option�ֶ�
-- ����������� namedsection
function Map.set(self, section, option, value)
	if type(value) ~= "table" or #value > 0 then
		if option then -- ����option ��ֵ��
			return self.uci:set(self.config, section, option, value)
		else -- ����������� namedsection
			return self.uci:set(self.config, section, value)
		end
	else -- ɾ��һ���ֶ�
		return Map.del(self, section, option)
	end
end

-- UCI del
function Map.del(self, section, option)
	if option then -- ɾ��һ���ֶ�
		return self.uci:delete(self.config, section, option)
	else -- ɾ��һ������
		return self.uci:delete(self.config, section)
	end
end

-- UCI get
function Map.get(self, section, option)
	if not section then -- ���������ļ�
		return self.uci:get_all(self.config)
	elseif option then -- ָ���ֶ�
		return self.uci:get(self.config, section, option)
	else -- ָ������
		return self.uci:get_all(self.config, section)
	end
end

--[[
Compound - Container
]]--
Compound = class(Node)

function Compound.__init__(self, ...)
	Node.__init__(self)
	self.template = "cbi/compound"
	self.children = {...}
end

function Compound.populate_delegator(self, delegator)
	for _, v in ipairs(self.children) do
		v.delegator = delegator
	end
end

function Compound.parse(self, ...)
	local cstate, state = 0

	for k, child in ipairs(self.children) do
		cstate = child:parse(...)
		state = (not state or cstate < state) and cstate or state
	end

	return state
end


--[[
Delegator - Node controller
]]--
Delegator = class(Node)
function Delegator.__init__(self, ...)
	Node.__init__(self, ...)
	self.nodes = {}
	self.defaultpath = {}
	self.pageaction = false
	self.readinput = true
	self.allow_reset = false
	self.allow_cancel = false
	self.allow_back = false
	self.allow_finish = false
	self.template = "cbi/delegator"
end

function Delegator.set(self, name, node)
	assert(not self.nodes[name], "Duplicate entry")

	self.nodes[name] = node
end

function Delegator.add(self, name, node)
	node = self:set(name, node)
	self.defaultpath[#self.defaultpath+1] = name
end

function Delegator.insert_after(self, name, after)
	local n = #self.chain + 1
	for k, v in ipairs(self.chain) do
		if v == after then
			n = k + 1
			break
		end
	end
	table.insert(self.chain, n, name)
end

function Delegator.set_route(self, ...)
	local n, chain, route = 0, self.chain, {...}
	for i = 1, #chain do
		if chain[i] == self.current then
			n = i
			break
		end
	end
	for i = 1, #route do
		n = n + 1
		chain[n] = route[i]
	end
	for i = n + 1, #chain do
		chain[i] = nil
	end
end

function Delegator.get(self, name)
	local node = self.nodes[name]

	if type(node) == "string" then
		node = load(node, name)
	end

	if type(node) == "table" and getmetatable(node) == nil then
		node = Compound(unpack(node))
	end

	return node
end

function Delegator.parse(self, ...)
	if self.allow_cancel and Map.formvalue(self, "cbi.cancel") then
		if self:_run_hooks("on_cancel") then
			return FORM_DONE
		end
	end

	if not Map.formvalue(self, "cbi.delg.current") then
		self:_run_hooks("on_init")
	end

	local newcurrent
	self.chain = self.chain or self:get_chain()
	self.current = self.current or self:get_active()
	self.active = self.active or self:get(self.current)
	assert(self.active, "Invalid state")

	local stat = FORM_DONE
	if type(self.active) ~= "function" then
		self.active:populate_delegator(self)
		stat = self.active:parse()
	else
		self:active()
	end

	if stat > FORM_PROCEED then
		if Map.formvalue(self, "cbi.delg.back") then
			newcurrent = self:get_prev(self.current)
		else
			newcurrent = self:get_next(self.current)
		end
	elseif stat < FORM_PROCEED then
		return stat
	end


	if not Map.formvalue(self, "cbi.submit") then
		return FORM_NODATA
	elseif stat > FORM_PROCEED
	and (not newcurrent or not self:get(newcurrent)) then
		return self:_run_hook("on_done") or FORM_DONE
	else
		self.current = newcurrent or self.current
		self.active = self:get(self.current)
		if type(self.active) ~= "function" then
			self.active:populate_delegator(self)
			local stat = self.active:parse(false)
			if stat == FORM_SKIP then
				return self:parse(...)
			else
				return FORM_PROCEED
			end
		else
			return self:parse(...)
		end
	end
end

function Delegator.get_next(self, state)
	for k, v in ipairs(self.chain) do
		if v == state then
			return self.chain[k+1]
		end
	end
end

function Delegator.get_prev(self, state)
	for k, v in ipairs(self.chain) do
		if v == state then
			return self.chain[k-1]
		end
	end
end

function Delegator.get_chain(self)
	local x = Map.formvalue(self, "cbi.delg.path") or self.defaultpath
	return type(x) == "table" and x or {x}
end

function Delegator.get_active(self)
	return Map.formvalue(self, "cbi.delg.current") or self.chain[1]
end

--[[
Page - A simple node
]]--

Page = class(Node)
Page.__init__ = Node.__init__
Page.parse    = function() end


--[[
SimpleForm - A Simple non-UCI form
ʵ����: startup.lua �� ipkg.lua
m = SimpleForm("initmgr", translate("Initscripts"), translate("You")
f = SimpleForm("rc", translate("Local Startup"),translate("This")
]]--

SimpleForm = class(Node)

function SimpleForm.__init__(self, config, title, description, data)
	Node.__init__(self, title, description)
	self.config = config      -- �ַ����� /etc/config�������ļ�����
	self.data = data or {}
	self.template = "cbi/simpleform"  -- ���� simpleform.htm
	self.dorender = true
	self.pageaction = false
	self.readinput = true -- true ��ҳ���ã����򷵻�false
end

SimpleForm.formvalue = Map.formvalue
SimpleForm.formvaluetable = Map.formvaluetable

function SimpleForm.parse(self, readinput, ...)
	self.readinput = (readinput ~= false) -- Ĭ������Ϊnil, ��self.readinput = true

	if self:formvalue("cbi.skip") then
		return FORM_SKIP
	end

	if self:formvalue("cbi.cancel") and self:_run_hooks("on_cancel") then
		return FORM_DONE
	end

	if self:submitstate() then -- SimpleForm.field ���ֵĴ���
		Node.parse(self, 1, ...) -- ����children, �����ӽڵ��parse,�ӽڵ��readinput����1
	end

	local valid = true
	for k, j in ipairs(self.children) do -- SimpleForm.section ���ֵĴ���
		for i, v in ipairs(j.children) do -- section.option ���ֵĴ���
			valid = valid -- ���valid��Ч��ֱ�ӷ��أ������ж� ȱʧ����Ч������ ������
			 and (not v.tag_missing or not v.tag_missing[1]) -- ���valid��Ч�򷵻�(not v.tag_missing or not v.tag_missing[1])
			 and (not v.tag_invalid or not v.tag_invalid[1]) -- ���valid��(not v.tag_missing or not v.tag_missing[1])����Ч
			 and (not v.error)       -- ���򷵻�(not v.error)
		end
	end

	local state =
		not self:submitstate() and FORM_NODATA -- δ�ύ���� FORM_NODATA
		or valid and FORM_VALID -- ���ύ���ύ����Ч���� FORM_VALID
		or FORM_INVALID         -- ���ύ������ȱʧ����Ч�������򷵻� FORM_INVALID

	self.dorender = not self.handle
	if self.handle then -- ����handle����ʱ�򣬴����ʼ��ʱ���뺯��
		local nrender, nstate = self:handle(state, self.data)
		self.dorender = self.dorender or (nrender ~= false)
		state = nstate or state
	end
	return state
end

function SimpleForm.render(self, ...)
	if self.dorender then
		Node.render(self, ...)
	end
end

function SimpleForm.submitstate(self)
	return self:formvalue("cbi.submit")
end

-- �൱��map��Map.section
-- ʹ�÷�ʽ  SimpleForm.section + SimpleSection
function SimpleForm.section(self, class, ...)
	if instanceof(class, AbstractSection) then
		local obj  = class(self, ...)
		self:append(obj)
		return obj
	else
		error("class must be a descendent of AbstractSection")
	end
end

-- Creates a child field
-- �൱��map��Map.section+AbstractSection.option��������ֱ�ӵ�option
-- f:field(TextValue, "lines")
-- h:field(TextValue, "lines3")
function SimpleForm.field(self, class, ...)
	local section
	for k, v in ipairs(self.children) do
		if instanceof(v, SimpleSection) then
			section = v
			break
		end
	end
	if not section then -- û��section���Զ�����һ��section
		section = self:section(SimpleSection)
	end

	if instanceof(class, AbstractValue) then -- ���DummyValue��AbstractSection��ʵ��
		local obj  = class(self, section, ...) -- ʵ����DummyValue��
		obj.track_missing = true
		section:append(obj) -- ���ص�obj׷�Ӹ�AbstractSection
		return obj -- ����obj
	else
		error("class must be a descendent of AbstractValue")
	end
end

function SimpleForm.set(self, section, option, value)
	self.data[option] = value
end


function SimpleForm.del(self, section, option)
	self.data[option] = nil
end


function SimpleForm.get(self, section, option)
	return self.data[option]
end


function SimpleForm.get_scheme()
	return nil
end


Form = class(SimpleForm)

function Form.__init__(self, ...)
	SimpleForm.__init__(self, ...)
	self.embedded = true
end


--[[
AbstractSection
]]--
AbstractSection = class(Node)

function AbstractSection.__init__(self, map, sectiontype, ...)
	Node.__init__(self, ...)
	self.sectiontype = sectiontype  -- �ַ��� ��ǰsection����            ��������
	self.map = map                  -- mapʵ��
	-- map.proceed �� map.changed
	-- map:formvaluetable �� map:get(section) map:del(section)  map:set(section, nil, self.sectiontype) 
	-- map:add(self.sectiontype) map:set(section, v.option, v.default)
	self.config = map.config        -- config �ַ�������ǰconfig����  �ļ��� �����ַ���"table"��ʾ����
	self.optionals = {} -- ��optional���ƵĽ�������optional=falseʱ��Ч
	self.defaults = {}  -- �½��������ֶε�Ĭ��ֵ
	self.fields = {}    -- table(k:string option�����֣� v abstractvalue ʵ��)
	self.tag_error = {} -- ��������Ƿ���ڴ���
	self.tag_invalid = {}  -- ��������Ƿ����invalid
	self.tag_deperror = {}
	self.changed = false

	self.optional = true
	self.addremove = false
	self.dynamic = false
end

-- Define a tab for the section tab="general" �ڲ�ʹ�ã� title="General Settings" �ⲿʹ��
--- s:tab("general",  translate("General Settings"))     ����general����ҳ
--- s:tab("logging",  translate("Logging"))              ����logging����ҳ
--- s:tab("language", translate("Language and Style"))   ����language����ҳ
function AbstractSection.tab(self, tab, title, desc)
	self.tabs      = self.tabs      or { } -- tab������ɶ��title,desc��childs��Ϣ
	self.tab_names = self.tab_names or { } -- ˳�򱣴�tab����

	self.tab_names[#self.tab_names+1] = tab
	self.tabs[tab] = {
		title       = title,
		description = desc,
		childs      = { }
	}
end

-- Check whether the section has tabs
function AbstractSection.has_tabs(self)
	return (self.tabs ~= nil) and (next(self.tabs) ~= nil)
end

-- Appends a new option
-- s:option(DummyValue, "index", translate("Start priority")) �Ƕ�Ӧ�����ļ�option��ֵ
-- 
function AbstractSection.option(self, class, option, ...)
	if instanceof(class, AbstractValue) then
		local obj  = class(self.map, self, option, ...)
		self:append(obj)
		self.fields[option] = obj
		return obj
	elseif class == true then
		error("No valid class was given and autodetection failed.")
	else
		error("class must be a descendant of AbstractValue")
	end
end

-- Appends a new tabbed option tab="general"
--- o = s:taboption("general", DummyValue, "_systime", translate("Local Time"))
--- tab="general" class=DummyValue, option="_systime", title="Local Time"
function AbstractSection.taboption(self, tab, ...)

	assert(tab and self.tabs and self.tabs[tab],
		"Cannot assign option to not existing tab %q" % tostring(tab))

	local l = self.tabs[tab].childs
	local o = AbstractSection.option(self, ...)

	if o then l[#l+1] = o end -- ׷�ӵ�tabs[tab].childs���

	return o
end

-- Render a single tab
function AbstractSection.render_tab(self, tab, ...)

	assert(tab and self.tabs and self.tabs[tab],
		"Cannot render not existing tab %q" % tostring(tab))

	local k, node
	for k, node in ipairs(self.tabs[tab].childs) do
		node.last_child = (k == #self.tabs[tab].childs) -- �����һ��ʱ��last_child = true
		node.index = k -- ��¼option��tabsetion��λ��
		node:render(...) -- ��ʾ
	end
end

-- Parse optional options
-- load��ʱ�򱻵���
function AbstractSection.parse_optionals(self, section, noparse)
	if not self.optional then -- 
		return
	end

	self.optionals[section] = {}

	local field = nil
	if not noparse then
		field = self.map:formvalue("cbi.opt."..self.config.."."..section)
	end

	for k,v in ipairs(self.children) do
		if v.optional and not v:cfgvalue(section) and not self:has_tabs() then
			if field == v.option then
				field = nil
				self.map.proceed = true
			else
				table.insert(self.optionals[section], v)
			end
		end
	end

	if field and #field > 0 and self.dynamic then
		self:add_dynamic(field)
	end
end

-- Add a dynamic option
function AbstractSection.add_dynamic(self, field, optional)
	local o = self:option(Value, field, field)
	o.optional = optional
end

-- Parse all dynamic options
function AbstractSection.parse_dynamic(self, section)
	if not self.dynamic then
		return
	end

	local arr  = luci.util.clone(self:cfgvalue(section))
	local form = self.map:formvaluetable("cbid."..self.config.."."..section)
	for k, v in pairs(form) do
		arr[k] = v
	end

	for key,val in pairs(arr) do
		local create = true

		for i,c in ipairs(self.children) do
			if c.option == key then
				create = false
			end
		end

		if create and key:sub(1, 1) ~= "." then
			self.map.proceed = true
			self:add_dynamic(key, true)
		end
	end
end

-- Returns the section's UCI table
-- ����ָ��������(����ÿ���ֶζ�Ӧһ������)
-- ���section����Ϊtable���򷵻�table��һ����¼
function AbstractSection.cfgvalue(self, section)
	return self.map:get(section)
end

-- Push events
-- ͨ��AbstractValueͨ��AbstractSection,ͨ��AbstractSection֪ͨMap
function AbstractSection.push_events(self)
	--luci.util.append(self.map.events, self.events)
	self.map.changed = true
end

-- Removes the section
function AbstractSection.remove(self, section)
	self.map.proceed = true
	return self.map:del(section)
end

-- Creates the section ����һ��section
function AbstractSection.create(self, section)
	local stat

	if section then -- ����һ������section
		stat = section:match("^[%w_]+$") and self.map:set(section, nil, self.sectiontype)
	else -- ����һ������section
		section = self.map:add(self.sectiontype)
		stat = section
	end

	if stat then
		for k,v in pairs(self.children) do -- ������ѡ�������Ĭ��ֵ
			if v.default then
				self.map:set(section, v.option, v.default)
			end
		end

		for k,v in pairs(self.defaults) do -- ������section�Դ�defaults��Ĭ��k-vֵ
			self.map:set(section, k, v)
		end
	end

	self.map.proceed = true

	return stat
end


--[[
������Map�£����ڲ���һ��������Section. ����:dhcp.lua network.lua
m:section(SimpleSection).template = "admin_network/lease_status"
m:section(SimpleSection).template = "admin_network/iface_overview"

]]--
SimpleSection = class(AbstractSection)

function SimpleSection.__init__(self, form, ...)
	AbstractSection.__init__(self, form, nil, ...)
	self.template = "cbi/nullsection"
end


Table = class(AbstractSection)
--[[
��������SimpleForm.section()��������
չʾ�������ļ����͵����ݼ�������startup.lua ipkg.lua��ϵͳ����״̬�Ͱ�����
startup.lua ���ڹ���������
ipkg.lua    ���ڹ���ϵͳ��װ��
]]--

function Table.__init__(self, form, data, ...)
	local datasource = {}        -- ��������
	local tself = self
	datasource.config = "table"  -- ����Դ����
	self.data = data or {}       -- ���ݼ�

	datasource.formvalue = Map.formvalue
	datasource.formvaluetable = Map.formvaluetable
	datasource.readinput = true

	-- ����map�ṩ��get, submitstate, del, get_scheme�⼸��������ʹ�ü̳й�����
	-- cfgvalue, remove �Ⱥ���ת��Ϊ��table�Ĳ���
	function datasource.get(self, section, option) -- ����section��/section[option]�ֶε�ֵ
		return tself.data[section] and tself.data[section][option]
	end

	function datasource.submitstate(self) -- ����"cbi.submit"������ֵ
		return Map.formvalue(self, "cbi.submit")
	end

	function datasource.del(...)
		return true
	end

	function datasource.get_scheme()
		return nil
	end

	AbstractSection.__init__(self, datasource, "table", ...)
	self.template = "cbi/tblsection"
	self.rowcolors = true
	self.anonymous = true
end

function Table.parse(self, readinput)
	self.map.readinput = (readinput ~= false)
	for i, k in ipairs(self:cfgsections()) do
		if self.map:submitstate() then
			Node.parse(self, k)
		end
	end
end

-- �������������� �� k-v���е�k�� ֻ��Table��TypedSection���������
function Table.cfgsections(self)
	local sections = {}

	for i, v in luci.util.kspairs(self.data) do
		table.insert(sections, i)
	end

	return sections
end

-- ���µ�ǰ����
function Table.update(self, data)
	self.data = data
end



--[[
NamedSection - A fixed configuration section defined by its name
An object describing an UCI section selected by the name
Use Map:section(NamedSection, ''name'', ''type'', ''title'', ''description'') to instantiate.

name: section name
type: section type
title: The title shown in the UI
description: description shown in the UI

.addremove = false
Allows the user to remove and recreate the configuration section

.dynamic = false
Marks this section as dynamic. Dynamic sections can contain an undefinded number of completely userdefined options.

.optional = true
Parse optional options

:option (optionclass, ...)
Creates a new option
    optionclass: a class object of the section
    additional parameters passed to the constructor of the option class
]]--
NamedSection = class(AbstractSection)

function NamedSection.__init__(self, map, section, stype, ...)
	AbstractSection.__init__(self, map, stype, ...)

	-- Defaults
	self.addremove = false
	self.template = "cbi/nsection"
	self.section = section
end

function NamedSection.prepare(self)
	AbstractSection.prepare(self)
	AbstractSection.parse_optionals(self, self.section, true)
end

function NamedSection.parse(self, novld)
	local s = self.section
	local active = self:cfgvalue(s)

	if self.addremove then -- �ܹ����ɾ��section
		local path = self.config.."."..s
		if active then -- Remove the sectionk
			if self.map:formvalue("cbi.rns."..path) and self:remove(s) then
				self:push_events()
				return
			end
		else           -- Create and apply default values
			if self.map:formvalue("cbi.cns."..path) then
				self:create(s)
				return
			end
		end
	end

	if active then
		AbstractSection.parse_dynamic(self, s)
		if self.map:submitstate() then
			Node.parse(self, s) -- �ݹ����children��parse
		end
		AbstractSection.parse_optionals(self, s)

		if self.changed then
			self:push_events()  -- Map.changed����Ϊtrue
		end
	end
end


--[[
TypedSection - A (set of) configuration section(s) defined by the type
	addremove: 	Defines whether the user can add/remove sections of this type
	anonymous:  Allow creating anonymous sections
	validate: 	a validation function returning nil if the section is invalid

An object describing a group of UCI sections selected by their type. 
Use Map:section(TypedSection, ''type'', ''title'', ''description'') to instantiate.
type: section type
title: The title shown in the UI
description: description shown in the UI
]]--
TypedSection = class(AbstractSection)

function TypedSection.__init__(self, map, type, ...)
	AbstractSection.__init__(self, map, type, ...)

	self.template = "cbi/tsection"
	self.deps = {}
	self.anonymous = false
end

function TypedSection.prepare(self)
	AbstractSection.prepare(self)

	local i, s
	for i, s in ipairs(self:cfgsections()) do
		AbstractSection.parse_optionals(self, s, true)
	end
end

-- Return all matching UCI sections for this TypedSection
-- ����ָ�����ͽ�����������
function TypedSection.cfgsections(self)
	local sections = {}
	self.map.uci:foreach(self.map.config, self.sectiontype,
		function (section) -- checkscope�ڴ˾Ϳ��Ծ�����Щsection����ʾ����Щ������ʾ
			if self:checkscope(section[".name"]) then
				table.insert(sections, section[".name"])
			end
		end)

	return sections
end

-- Limits scope to sections that have certain option => value pairs
-- Only select those sections where the option key == value<br /> 
-- If you call this function several times the dependencies will be linked with or
function TypedSection.depends(self, option, value)
	table.insert(self.deps, {option=option, value=value})
end

function TypedSection.parse(self, novld)
	if self.addremove then -- ���ÿ�����ɾѡ��ʱ���ſ���ɾ������
		-- Remove
		-- form-data;name=\"cbi.rts.firewall.cfg2a3837\"
		-- cbi.rts.firewall.cfg283837 = 'Delete'
		local crval = REMOVE_PREFIX .. self.config
		local name = self.map:formvaluetable(crval)
		for k,v in pairs(name) do
			if k:sub(-2) == ".x" then
				k = k:sub(1, #k - 2)
			end -- k = cfg283837
			if self:cfgvalue(k) and self:checkscope(k) then -- checkscope�ڴ˽�һ��ȷ���ܷ�ɾ��
				self:remove(k)
			end
		end
	end

	local co -- ���������ֶ�
	for i, k in ipairs(self:cfgsections()) do
		AbstractSection.parse_dynamic(self, k)
		if self.map:submitstate() then
			Node.parse(self, k, novld)
		end
		AbstractSection.parse_optionals(self, k)
	end

	if self.addremove then
		-- Create
		local created
		local crval = CREATE_PREFIX .. self.config .. "." .. self.sectiontype
		local origin, name = next(self.map:formvaluetable(crval))
		if self.anonymous then -- ����
			if name then
				created = self:create(nil, origin)
			end
		else
			if name then
				-- Ignore if it already exists ͬ����ͻ
				if self:cfgvalue(name) then
					name = nil;
				end

				name = self:checkscope(name)

				if not name then
					self.err_invalid = true
				end

				if name and #name > 0 then -- ��������
					created = self:create(name, origin) and name
					if not created then
						self.invalid_cts = true
					end
				end
			end
		end

		if created then
			AbstractSection.parse_optionals(self, created)
		end
	end

	if self.sortable then -- "cbi.sts." �˹��ܺ���
		local stval = RESORT_PREFIX .. self.config .. "." .. self.sectiontype
		local order = self.map:formvalue(stval)
		if order and #order > 0 then
			local sid
			local num = 0
			for sid in util.imatch(order) do
				self.map.uci:reorder(self.config, sid, num)
				num = num + 1
			end
			self.changed = (num > 0)
		end
	end

	if created or self.changed then
		self:push_events()
	end
end

-- Verifies scope of sections
-- ʵ�ֹ��˹��ܺ�option֮����������
function TypedSection.checkscope(self, section)
	-- Check if we are not excluded
	-- ���˹���
	if self.filter and not self:filter(section) then
		return nil
	end

	-- Check if at least one dependency is met
	-- options֮����������
	if #self.deps > 0 and self:cfgvalue(section) then
		local stat = false

		for k, v in ipairs(self.deps) do
			if self:cfgvalue(section)[v.option] == v.value then
				stat = true
			end
		end

		if not stat then
			return nil
		end
	end

	-- validate ��Ч�Լ��
	return self:validate(section)
end


-- Dummy validate function
function TypedSection.validate(self, section)
	return section
end


--[[
AbstractValue - An abstract Value Type
	null:		Value can be empty
	valid:		A function returning the value if it is valid otherwise nil
	depends:	A table of option => value pairs of which one must be true
	default:	The default value
	size:		The size of the input fields
	rmempty:	Unset value if empty
	optional:	This value is optional (see AbstractSection.optionals)
]]--
AbstractValue = class(Node)

function AbstractValue.__init__(self, map, section, option, ...)
	Node.__init__(self, ...)
	self.section = section -- �ַ�������ǰsection����           ��������
	self.option  = option  -- �ַ�������ǰoption ����           ѡ������
	self.map     = map     -- Map ʵ����
	--  Generates the unique CBID
	-- map:formvalue(key) �� map.save = false�� map:get(section, self.option)  
	-- map:set(section, self.option, value) �� map:del(section, self.option)
	self.config  = map.config -- config �ַ�������ǰconfig����  �ļ���
	self.tag_invalid = {} -- ��Ч��
	self.tag_missing = {} -- ȱʧ��
	self.tag_reqerror = {} -- ��������
	self.tag_error = {}    -- �����
	self.deps = {} -- ��������option
	--self.cast = "string"

	self.track_missing = false
	self.rmempty   = true
	self.default   = nil
	self.size      = nil
	self.optional  = false
end

function AbstractValue.prepare(self)
	self.cast = self.cast or "string"
end

-- depends (key, value)
-- Only show this option field if another option key is set to value in the same section.<br /> 
-- If you call this function several times the dependencies will be linked with or
-- 
-- Add a dependencie to another section field
-- br:depends("proto", "static")
-- stp:depends("type", "bridge")
-- auth_port:depends({mode="ap-wds", encryption="wpa2"})
-- DynamicList.depends("enable", "1")  system.lua��ntp server��������ϵͳʹ��ntpclient�ͻ���
function AbstractValue.depends(self, field, value)
	local deps
	if type(field) == "string" then
		deps = {}
	 	deps[field] = value
	else
		deps = field
	end

	table.insert(self.deps, deps)
end

-- Serialize dependencies
function AbstractValue.deplist2json(self, section, deplist)
	local deps, i, d = { }

	if type(self.deps) == "table" then
		for i, d in ipairs(deplist or self.deps) do
			local a, k, v = { }
			for k, v in pairs(d) do
				if k:find("!", 1, true) then
					a[k] = v
				elseif k:find(".", 1, true) then
					a['cbid.%s' % k] = v
				else
					a['cbid.%s.%s.%s' %{ self.config, section, k }] = v
				end
			end
			deps[#deps+1] = a
		end
	end

	return util.serialize_json(deps)
end

-- Generates the unique CBID
-- name=cbid ͬʱ id=cbid; ��: cbid���ֶμ���ģ������ļ�������ѡ���ҳ����Ψһcbid��������
-- cbid����ͨ��section�������޶���������֮��������������ԣ�
function AbstractValue.cbid(self, section)
	return "cbid."..self.map.config.."."..section.."."..self.option
end

-- Return whether this object should be created
-- ��ȡ cbi.opt.${config}.${section} ��Ӧ��ֵ 
function AbstractValue.formcreated(self, section)
	local key = "cbi.opt."..self.config.."."..section
	return (self.map:formvalue(key) == self.option)
end

-- Returns the formvalue for this object
-- m:formvalue("_newfwd.extzone")
-- local v1 = pw1:formvalue("_pass")  -- pw1 = s:option(Value, "pw1", translate("Password"))     "_pass" s.cfgsections()
-- local v2 = pw2:formvalue("_pass")  -- pw2 = s:option(Value, "pw2", translate("Confirmation")) "_pass" s.cfgsections()
function AbstractValue.formvalue(self, section)
	return self.map:formvalue(self:cbid(section))
end

function AbstractValue.additional(self, value)
	self.optional = value
end

-- ǿ�Ƶ�; �����; ��ί�е�
function AbstractValue.mandatory(self, value)
	self.rmempty = not value
end

-- 
function AbstractValue.add_error(self, section, type, msg)
	self.error = self.error or { }
	self.error[section] = msg or type -- �����¼��������

	self.section.error = self.section.error or { }
	self.section.error[section] = self.section.error[section] or { }
	table.insert(self.section.error[section], msg or type) -- section ��¼��������

	if type == "invalid" then
		self.tag_invalid[section] = true -- ��¼��ǩ��Ч
	elseif type == "missing" then
		self.tag_missing[section] = true -- ��¼��ǩȱʧ
	end

	self.tag_error[section] = true -- ��¼��ǩ����
	self.map.save = false  -- map �ύ���󣬲��ܱ���
end

-- novld ��ʾ��������Ч�Ļ�ȡֵ
function AbstractValue.parse(self, section, novld)
	local fvalue = self:formvalue(section)
	local cvalue = self:cfgvalue(section)

	-- If favlue and cvalue are both tables and have the same content
	-- make them identical
	if type(fvalue) == "table" and type(cvalue) == "table" then
		local equal = #fvalue == #cvalue
		if equal then
			for i=1, #fvalue do
				if cvalue[i] ~= fvalue[i] then
					equal = false
				end
			end
		end
		if equal then
			fvalue = cvalue
		end
	end

	if fvalue and #fvalue > 0 then -- If we have a form value, write it to UCI
		local val_err
		fvalue, val_err = self:validate(fvalue, section)
		fvalue = self:transform(fvalue)

		if not fvalue and not novld then -- �ύ�����������ݲ���Ҫ��
			self:add_error(section, "invalid", val_err)
		end

		if fvalue and (self.forcewrite or not (fvalue == cvalue)) then -- ���ǿ��write����ô��ʹfvalue == cvalueҲд��
			if self:write(section, fvalue) then
				-- Push events
				self.section.changed = true
				--luci.util.append(self.map.events, self.events)
			end
		end
	else							-- Unset the UCI or error
		if self.rmempty or self.optional then
			if self:remove(section) then -- ɾ������
				-- Push events
				self.section.changed = true
				--luci.util.append(self.map.events, self.events)
			end
		elseif cvalue ~= fvalue and not novld then -- ȱʧһЩ���ݣ�������������
			-- trigger validator with nil value to get custom user error msg.
			local _, val_err = self:validate(nil, section)
			self:add_error(section, "missing", val_err)
		end
	end
end

-- Render if this value exists or if it is mandatory
function AbstractValue.render(self, s, scope)
    -- self.optional = true      section:has_tabs() = false cfgvalue(s) = false then call self:formcreated
	if not self.optional or self.section:has_tabs() or self:cfgvalue(s) or self:formcreated(s) then
		scope = scope or {}
		scope.section = s
		scope.cbid    = self:cbid(s)
		Node.render(self, scope)
	end
end

-- Return the UCI value of this object
-- ����AbstractValue������ֵ���ȴ�webҳ���ȡ������������ļ���ȡ��
-- ����ֵ��nil, string, table
function AbstractValue.cfgvalue(self, section)
	local value
	if self.tag_error[section] then
		value = self:formvalue(section)
	else
		value = self.map:get(section, self.option)
	end

	if not value then
		return nil
	elseif not self.cast or self.cast == type(value) then -- return string
		return value
	elseif self.cast == "string" then  -- return string (table cast to string)
		if type(value) == "table" then
			return value[1]
		end
	elseif self.cast == "table" then -- return table
		return { value }
	end
end

-- Validate the form value
function AbstractValue.validate(self, value)
	if self.datatype and value then
		if type(value) == "table" then
			local v
			for _, v in ipairs(value) do
				if v and #v > 0 and not verify_datatype(self.datatype, v) then
					return nil
				end
			end
		else
			if not verify_datatype(self.datatype, value) then
				return nil
			end
		end
	end

	return value
end

AbstractValue.transform = AbstractValue.validate


-- Write to UCI
--- function Value.write(self, section, value)  ��system.lua
function AbstractValue.write(self, section, value)
	return self.map:set(section, self.option, value)
end

-- Remove from UCI
function AbstractValue.remove(self, section)
	return self.map:del(section, self.option)
end




--[[
Value - A one-line value
	maxlength:	The maximum length
	default = nil The default value 
	optional = false Marks this option as optional, implies .rmempty = true
	rmempty = true	 Removes this option from the configuration file when the user enters an empty value
	size = nil       The size of the form field
	
1. �����޸����ݵ������
2. �������޸����ݵ������
3. �����������ܵ������
4. password���������

NamedSection:option(Value, ''option'', ''title'', ''description'')
TypedSection:option(Value, ''option'', ''title'', ''description'')
option: section name
title: The title shown in the UI
description: description shown in the UI
]]--
Value = class(AbstractValue)

---  Value.datatype = "hostname"
function Value.__init__(self, ...)
	AbstractValue.__init__(self, ...)
	self.template  = "cbi/value"
	self.keylist = {}    -- �ؼ���ѡ��
	self.vallist = {}    -- �ؼ���ֵѡ��
	self.readonly = nil  -- ֻ��ѡ��
end

function Value.reset_values(self)
	self.keylist = {}
	self.vallist = {}
end

-- Convert this text field into a combobox if possible and add a selection option.
-- v:value("REJECT", translate("reject"))
-- v:value("DROP", translate("drop"))
-- v:value("ACCEPT", translate("accept"))
function Value.value(self, key, val) 
	val = val or key
	table.insert(self.keylist, tostring(key))
	table.insert(self.vallist, tostring(val))
end

function Value.parse(self, section, novld)
	if self.readonly then return end -- ֻ��ѡ��
	AbstractValue.parse(self, section, novld)
end

-- DummyValue - This does nothing except being there
DummyValue = class(AbstractValue)

--[[
1. ��Tableһ��ʹ�ã���ʾ���������
2. ��Sectionһ��ʹ�ã���ʾ���������, ��forward������ʾ����������ݵ�ֵ
]]--

--- o.template = "admin_system/clock_status"  �� system.lua �У��޸���ʾtemplate
function DummyValue.__init__(self, ...)
	AbstractValue.__init__(self, ...)
	self.template = "cbi/dvalue" -- ��仰o.template����template/cbi/dvalue.htm�ļ�
	self.value = nil
end

function DummyValue.cfgvalue(self, section)
	local value
	if self.value then
		if type(self.value) == "function" then
			value = self:value(section)
		else
			value = self.value
		end
	else
		value = AbstractValue.cfgvalue(self, section)
	end
	return value
end

function DummyValue.parse(self)

end


--[[
Flag - A flag being enabled or disabled
�����ڹ��ܵĿ����͹رգ����Թ��ǿ������հ��ǲ�����
NamedSection:option(Value, ''option'', ''title'', ''description'')
TypedSection:option(Value, ''option'', ''title'', ''description'')
]]--
Flag = class(AbstractValue)

function Flag.__init__(self, ...)
	AbstractValue.__init__(self, ...)
	self.template  = "cbi/fvalue"

	self.enabled  = "1"  -- ʹ��Ĭ��ֵ
	self.disabled = "0"  -- ������Ĭ��ֵ
	self.default  = self.disabled -- Ĭ��ֵ
end

-- A flag can only have two states: set or unset
function Flag.parse(self, section, novld)
	local fexists = self.map:formvalue(
		FEXIST_PREFIX .. self.config .. "." .. section .. "." .. self.option)

	if fexists then
		local fvalue = self:formvalue(section) and self.enabled or self.disabled -- ��ֵ����ʹ�ܣ������ǲ�ʹ��
		local cvalue = self:cfgvalue(section)
		local val_err
		fvalue, val_err = self:validate(fvalue, section)
		if not fvalue then
			if not novld then
				self:add_error(section, "invalid", val_err)
			end
			return
		end
		-- ҳ������ֵ����Ĭ��ֵ���Ҹö��� optional �� rmempty ����Ϊtrue�� ��ɾ����������
		if fvalue == self.default and (self.optional or self.rmempty) then
			self:remove(section)
		else
			self:write(section, fvalue)
		end
		-- fvalue ~= cvalue �� ���������仯
		if (fvalue ~= cvalue) then self.section.changed = true end
	else
		self:remove(section)
		self.section.changed = true
	end
end

function Flag.cfgvalue(self, section) -- �����ļ�ûֵ�򷵻�Ĭ��ֵ
	return AbstractValue.cfgvalue(self, section) or self.default
end
function Flag.validate(self, value)
	return value
end

--[[
ListValue - A one-line value predefined in a list
	widget: The widget that will be used (select, radio)
�򵥵������˵��� �� forward.lua
NamedSection:option(Value, ''option'', ''title'', ''description'')
TypedSection:option(Value, ''option'', ''title'', ''description'')
]]--
ListValue = class(AbstractValue)

--- �����ع� function ListValue.write(self, section, value)
function ListValue.__init__(self, ...)
	AbstractValue.__init__(self, ...)
	self.template  = "cbi/lvalue"

	self.size   = 1
	self.widget = "select" -- .widget = "select"
			-- selects the form widget to be used
	self:reset_values()
end

function ListValue.reset_values(self)
	self.keylist = {}
	self.vallist = {}
	self.deplist = {}
end

-- Adds an entry to the selection list
-- ListValue:value("UTC")  �����б�ѡ����
-- for i, zone in ipairs(zones.TZ) do
-- 	ListValue:value(zone[1]) 
-- end
function ListValue.value(self, key, val, ...)       -- �������ѡ��
	if luci.util.contains(self.keylist, key) then
		return
	end

	val = val or key
	table.insert(self.keylist, tostring(key))
	table.insert(self.vallist, tostring(val))
	table.insert(self.deplist, {...})
end

function ListValue.validate(self, val)
	if luci.util.contains(self.keylist, val) then
		return val
	else
		return nil
	end
end



--[[
MultiValue - Multiple delimited values
	widget: The widget that will be used (select, checkbox)
	delimiter: The delimiter that will separate the values (default: " ")
1. �����кܶ�ѡ�ͬʱѡ��; ���ѡ��ƽ����ʾ������������ʾ ��select �� checkbox������ʽ
]]--
MultiValue = class(AbstractValue)

function MultiValue.__init__(self, ...)
	AbstractValue.__init__(self, ...)
	self.template = "cbi/mvalue"

	self.widget = "checkbox"
	self.delimiter = " "  -- �ָ���

	self:reset_values()
end

function MultiValue.render(self, ...)
	if self.widget == "select" and not self.size then
		self.size = #self.vallist
	end

	AbstractValue.render(self, ...)
end

function MultiValue.reset_values(self)
	self.keylist = {}
	self.vallist = {}
	self.deplist = {}
end

function MultiValue.value(self, key, val)
	if luci.util.contains(self.keylist, key) then
		return
	end

	val = val or key
	table.insert(self.keylist, tostring(key))
	table.insert(self.vallist, tostring(val))
end

function MultiValue.valuelist(self, section)
	local val = self:cfgvalue(section)

	if not(type(val) == "string") then
		return {}
	end

	return luci.util.split(val, self.delimiter)
end

function MultiValue.validate(self, val)
	val = (type(val) == "table") and val or {val}

	local result

	for i, value in ipairs(val) do
		if luci.util.contains(self.keylist, value) then
			result = result and (result .. self.delimiter .. value) or value
		end
	end

	return result
end


--[[
 �����ã�����
]]--
StaticList = class(MultiValue)

function StaticList.__init__(self, ...)
	MultiValue.__init__(self, ...)
	self.cast = "table" -- ����tableֵ
	self.valuelist = self.cfgvalue

	if not self.override_scheme
	 and self.map:get_scheme(self.section.sectiontype, self.option) then
		local vs = self.map:get_scheme(self.section.sectiontype, self.option)
		if self.value and vs.values and not self.override_values then
			for k, v in pairs(vs.values) do
				self:value(k, v)
			end
		end
	end
end

function StaticList.validate(self, value)
	value = (type(value) == "table") and value or {value}

	local valid = {}
	for i, v in ipairs(value) do
		if luci.util.contains(self.keylist, v) then
			table.insert(valid, v)
		end
	end
	return valid
end

--[[
����ʱ������������ֶΣ�list����
]]--
DynamicList = class(AbstractValue)

-- o = s:option(DynamicList, "server", translate("NTP server candidates")) /etc/config/system��list��ʾ��ʽ
function DynamicList.__init__(self, ...)
	AbstractValue.__init__(self, ...)
	self.template  = "cbi/dynlist"
	self.cast = "table"  -- ����tableֵ
	self:reset_values()
end

function DynamicList.reset_values(self)
	self.keylist = {}
	self.vallist = {}
end

function DynamicList.value(self, key, val)
	val = val or key
	table.insert(self.keylist, tostring(key))
	table.insert(self.vallist, tostring(val))
end

function DynamicList.write(self, section, value)
	local t = { }

	if type(value) == "table" then
		local x
		for _, x in ipairs(value) do
			if x and #x > 0 then
				t[#t+1] = x
			end
		end
	else
		t = { value }
	end

	if self.cast == "string" then
		value = table.concat(t, " ")
	else
		value = t
	end

	return AbstractValue.write(self, section, value)
end

function DynamicList.cfgvalue(self, section)
	local value = AbstractValue.cfgvalue(self, section)

	if type(value) == "string" then
		local x
		local t = { }
		for x in value:gmatch("%S+") do
			if #x > 0 then
				t[#t+1] = x
			end
		end
		value = t
	end

	return value
end

function DynamicList.formvalue(self, section)
	local value = AbstractValue.formvalue(self, section)

	if type(value) == "string" then
		if self.cast == "string" then
			local x
			local t = { }
			for x in value:gmatch("%S+") do
				t[#t+1] = x
			end
			value = t
		else
			value = { value }
		end
	end

	return value
end


--[[
TextValue - A multi-line value
	rows:	Rows
�������ļ����룬���ļ������޸�����˳������em350�����ȵ�
]]--
TextValue = class(AbstractValue)

function TextValue.__init__(self, ...)
	AbstractValue.__init__(self, ...)
	self.template  = "cbi/tvalue"
end

--[[
Button
�����ڹ��ܵĿ����͹رգ����һ���ǿ�������ô�ٴε�����ǹرա�
��startup�У��кܺõ�ʵ����
]]--
Button = class(AbstractValue)

function Button.__init__(self, ...)
	AbstractValue.__init__(self, ...)
	self.template  = "cbi/button"
	self.inputstyle = nil
	self.rmempty = true
    self.unsafeupload = false
end


FileUpload = class(AbstractValue)

function FileUpload.__init__(self, ...)
	AbstractValue.__init__(self, ...)
	self.template = "cbi/upload"
	if not self.map.upload_fields then
		self.map.upload_fields = { self }
	else
		self.map.upload_fields[#self.map.upload_fields+1] = self
	end
end

function FileUpload.formcreated(self, section)
	if self.unsafeupload then
		return AbstractValue.formcreated(self, section) or
			self.map:formvalue("cbi.rlf."..section.."."..self.option) or
			self.map:formvalue("cbi.rlf."..section.."."..self.option..".x") or
			self.map:formvalue("cbid."..self.map.config.."."..section.."."..self.option..".textbox")
	else
		return AbstractValue.formcreated(self, section) or
			self.map:formvalue("cbid."..self.map.config.."."..section.."."..self.option..".textbox")
	end
end

function FileUpload.cfgvalue(self, section)
	local val = AbstractValue.cfgvalue(self, section)
	if val and fs.access(val) then
		return val
	end
	return nil
end

-- If we have a new value, use it
-- otherwise use old value
-- deletion should be managed by a separate button object
-- unless self.unsafeupload is set in which case if the user
-- choose to remove the old file we do so.
-- Also, allow to specify (via textbox) a file already on router
function FileUpload.formvalue(self, section)
	local val = AbstractValue.formvalue(self, section)
	if val then
		if self.unsafeupload then
			if not self.map:formvalue("cbi.rlf."..section.."."..self.option) and
		   	    not self.map:formvalue("cbi.rlf."..section.."."..self.option..".x")
			then
				return val
			end
			fs.unlink(val)
			self.value = nil
			return nil
                elseif val ~= "" then
			return val
                end
	end
	val = luci.http.formvalue("cbid."..self.map.config.."."..section.."."..self.option..".textbox")
	if val == "" then
		val = nil
	end
        if not self.unsafeupload then
		if not val then
			val = self.map:formvalue("cbi.rlf."..section.."."..self.option)
		end
        end
	return val
end

function FileUpload.remove(self, section)
	if self.unsafeupload then
		local val = AbstractValue.formvalue(self, section)
		if val and fs.access(val) then fs.unlink(val) end
		return AbstractValue.remove(self, section)
	else
		return nil
	end
end

FileBrowser = class(AbstractValue)

function FileBrowser.__init__(self, ...)
	AbstractValue.__init__(self, ...)
	self.template = "cbi/browser"
end
