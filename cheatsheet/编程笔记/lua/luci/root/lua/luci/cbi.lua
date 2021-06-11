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

FORM_NODATA  =  0 -- 接收web的form中没有"cbi.submit"
FORM_PROCEED =  0 -- FORM_PROCEED =  1 接收web包数据未读取完毕
FORM_VALID   =  1 -- 接收数据 不invalid marked proceed, and has not changed.
FORM_DONE	 =  1 -- 接收web的form中没有 "cbi.cancel" 或者 "on_cancel" hook function返回true
FORM_INVALID = -1 -- 接收web的form中没有 save 变量 或者 section|option 产生一个error
FORM_CHANGED =  2 -- formvalue 中数据已经写入/etc/config/uci中
FORM_SKIP    =  4 -- 接收web的form中有 "cbi.skip"

AUTO = true

CREATE_PREFIX = "cbi.cts."
REMOVE_PREFIX = "cbi.rts."
RESORT_PREFIX = "cbi.sts."
FEXIST_PREFIX = "cbi.cbe."

-- Loads a CBI map from given file, creating an environment and returns it
-- Delegator 使用，当前工程中没有使用Delegator的网页，先不分析
function load(cbimap, ...)
	local fs   = require "nixio.fs"
	local i18n = require "luci.i18n"
	require("luci.config")  -- 见luci.config.lua说明，其实就是引入全局变量 uci,ubus,luci,model,template等
	require("luci.util")    -- 引入template, luci, debug, ubus 几个环境变量

	local upldir = "/etc/luci-uploads/"
	local cbidir = luci.util.libpath() .. "/model/cbi/"
	local func, err
-- 函数从参数filename指定的文件中加载内容，并将内容封装在一个函数中返回
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
	 	arg={...} -- 不定长参数.  arg[1] = arg[1] or "" 显示配置页面分离时使用过此参数
	}
-- setfenv(f, table)
-- 设置参数func所指定函数使用的当前环境，参数func可以是一个lua函数也可以是一个指定函数调用层次的数字
-- 当参数为1时，表示正在调用函数setfenv()函数的函数，这个函数的返回值是参数func所指定的函数
	setfenv(func, setmetatable(env, {__index =
		function(tbl, key)
			return rawget(tbl, key) or _M[key] or _G[key]
		end}))

	local maps       = { func() } -- 函数调用，返回一个或多个map实例
	local uploads    = { }
	local has_upload = false

	for i, map in ipairs(maps) do
		if not instanceof(map, Node) then
			error("CBI map returns no valid map object!")
			return nil
		else
			map:prepare() -- 调用prepare；NamedSection TypeSection AbstractValue都有该函数
			if map.upload_fields then -- 只有FileUpload 对象有此成员变量
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
-- 为以后判断构建一个类型规则
local cdt_cache = { }

-- 按照协议思路: 将一个字符串按照协议转换为表结构
-- 通过code(datatype)规则获得对应的处理函数
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
					elseif type(datatypes[label]) == "function" then -- datatypes 表
						stack[#stack+1] = datatypes[label] -- 赋值函数，添加表
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

-- 判断value是否符合dt(datatype)规则
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
-- 分离过程，抽象接口；构造数据结构，抽象数据管理接口
Node = class()

-- title 字符串
-- description 字符串
function Node.__init__(self, title, description)
	self.children = {}
	self.title = title or ""
	self.description = description or ""
	self.template = "cbi/node"
end

-- hook helper
-- 执行字符串名字为hook的钩子函数；钩子函数的参数为self即自身
-- hook钩子函数，需要在类创建的时候构建；
function Node._run_hook(self, hook)
	if type(self[hook]) == "function" then
		return self[hook](self)
	end
end

-- 执行字符串名字为可变参数的钩子函数；钩子函数的参数为self即自身
-- hook钩子函数，需要在类创建的时候构建；
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
-- Map是Node的子类，那么map.parse会执行Node.parse()方法，function Node.parse(self, ...)
-- end在此函数执行之前，调用Node.__init__(self, title, description),self.children = {}
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
-- 在cbi(SimpleForm)实例上附加htm模板，该实例没有title和description，只有template模板

function Template.__init__(self, template)
-- 参数不提供的情况下，默认参数是nil
--  Node.__init__(self, nil, nil)
	Node.__init__(self)
	self.template = template
end

-- 相比Node的render函数，没有scope参数
-- Template简化了Node的render函数
function Template.render(self)
    -- Node可以传表参，同时将自身传递过去。
    -- Template 只能将自身传递过去
	luci.template.render(self.template, {self=self})
end

-- 相比Node的parse函数，增添了readinput参数；
-- Node依赖实例化子类；Template实现parse函数

-- 然后调用Map.formvalue(self, key) return self.readinput and luci.http.formvalue(key)
-- 调用http.lua中formvalue()可以得到界面里面的数据。
function Template.parse(self, readinput)
	self.readinput = (readinput ~= false)
	-- 如果页面有cbi.submit则返回FORM_DONE, 否则返回FORM_NODATA
	return Map.formvalue(self, "cbi.submit") and FORM_DONE or FORM_NODATA -- cbi.submit 见header.htm
	-- value = condition and trueval or falseval;   -- condtion == true时，返回trueval 失败时返回falseval
	-- value = (condition and trueval) or falseval; -- and有着比or更高的优先级
end

-- Map是Node的子类，那么map.parse会执行Node.parse()方法，function Node.parse(self, ...) 
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

	self.config = config            -- 字符串， /etc/config下配置文件名称
	self.parsechain = {self.config} -- 关联的多个/etc/config下配置文件名称
	self.template = "cbi/map"       -- 关联 map.htm
	self.apply_on_parse = nil -- The flag that tells the map to apply all values when parsed
	self.readinput = true -- true 从页面获得；否则返回false if the map should read input or not boolean
	self.proceed = false -- children修改，说明已经解析过
	self.flow = {} -- skip， hideapplybtn， hidesavebtn， hideresetbtn 控制页面显示

	self.uci = uci.cursor()
	self.save = true -- 判断能否提交

	self.changed = false -- 让children判断提交内容是否发生变化

	-- 配置文件不存在则创建配置文件
	local path = "%s/%s" %{ self.uci:get_confdir(), self.config }
	if fs.stat(path, "type") ~= "reg" then
		fs.writefile(path, "")
	end

	-- 如果加载配置文件失败，
	local ok, err = self.uci:load(self.config)
	if not ok then -- 通过请求url的cbi.source字段，得到配置文件
		local url = dispatcher.build_url(unpack(dispatcher.context.request))
		local source = self:formvalue("cbi.source") -- 获得文件配置内容，
		if type(source) == "string" then -- 保存在配置文件中
			fs.writefile(path, source:gsub("\r\n", "\n"))
			ok, err = self.uci:load(self.config)
			if ok then
				luci.http.redirect(url)
			end
		end
		self.save = false
	end

	-- 加载失败则返回错误
	if not ok then
		self.template   = "cbi/error" -- 错误htm
		self.error      = err         -- 错误提示
		self.source     = fs.readfile(path) or "" -- 错误配置文件内容
		self.pageaction = false -- 
	end
end

-- 字符串   页面响应数据
-- false    没有从页面返回 readinput = false
-- nil      页面没有数据
function Map.formvalue(self, key) -- 转 luci.http.formvalue
	return self.readinput and luci.http.formvalue(key) or nil
end

-- table    空表: 页面没有数据；页面有数据
-- false    没有从页面返回 readinput = false
-- luci.http.formvaluetable("delzone")
-- 
function Map.formvaluetable(self, key) -- 转 luci.http.formvaluetable
	return self.readinput and luci.http.formvaluetable(key) or {}
end

-- 不知道
function Map.get_scheme(self, sectiontype, option)
	if not option then
		return self.scheme and self.scheme.sections[sectiontype]
	else
		return self.scheme and self.scheme.variables[sectiontype]
		 and self.scheme.variables[sectiontype][option]
	end
end

-- 返回cbi.submit的值
function Map.submitstate(self)
	return self:formvalue("cbi.submit")
end

-- Chain foreign config
-- 向map中插入外部的config信息
--- m:chain("luci") 见 system.lua 在链接/etc/config/system之后，再链接/etc/config/luci配置文件
function Map.chain(self, config)
	table.insert(self.parsechain, config)
end

-- 待实现，且没有实现
function Map.state_handler(self, state)
	return state
end

-- Use optimized UCI writing
-- 调用Node.parse(self, ...),(uci主要是与luci进行数据交互的平台。)
-- Map总是在children都parse之后再进行parse,而children会修改self.save告知能提交处理
function Map.parse(self, readinput, ...)
	if self:formvalue("cbi.skip") then -- 忽略FORM_SKIP
		self.state = FORM_SKIP
	elseif not self.save then -- 数据无效
		self.state = FORM_INVALID
	elseif not self:submitstate() then -- 没有提交
		self.state = FORM_NODATA
	end

	-- Back out early to prevent unauthorized changes on the subsequent parse 已经有状态了，直接返回即可
	if self.state ~= nil then
		return self:state_handler(self.state)
	end

	self.readinput = (readinput ~= false)
	self:_run_hooks("on_parse") 

    -- 依次调用children的parse函数
	Node.parse(self, ...)
-- 如果map的保存按钮被点击,或者其他按钮被点击，都会触发uci里面的函数，来处理相关操作。
-- 比如：on_save, on_before_save,on_after_save, on_before_commit, on_after_commit,on_before_apply之类
	if self.save then 
		self:_run_hooks("on_save", "on_before_save")
		for i, config in ipairs(self.parsechain) do -- 保存配置文件内容  到临时存储器
			self.uci:save(config) -- Saves changes made to a config to make them committable.
		end
		self:_run_hooks("on_after_save")
		if (not self.proceed and self.flow.autoapply) or luci.http.formvalue("cbi.apply") then
			self:_run_hooks("on_before_commit")
			for i, config in ipairs(self.parsechain) do -- 提交配置文件内容 到/etc/config实际存储区
				self.uci:commit(config) -- Commit saved changes.

				-- Refresh data because commit changes section names
				self.uci:load(config)
			end
			self:_run_hooks("on_commit", "on_after_commit", "on_before_apply")
			if self.apply_on_parse then  -- 重新启动任务  
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
			self:commit_handler(self:submitstate()) -- 如果map的提交按钮被点击
		end
	end

	if not self.save then -- 如果没有点击save按钮
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


-- 在dispatcher.lua 中_cbi中被调用，传递各种参数的表
function Map.render(self, ...)
	self:_run_hooks("on_init") -- 输出网页前调用
	Node.render(self, ...)
end

-- Creates a child section 传递类构建函数，返回类实例
-- Map:section创建了一个子section,其中如果是abstraction的实例，那么调用Node:append()中table.insert(self.children, obj)语句。
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
-- 添加匿名节区 typedsection
function Map.add(self, sectiontype)
	return self.uci:add(self.config, sectiontype)
end

-- UCI set
-- 设置option 有值；
-- 删除option字段
-- 添加命名节区 namedsection
function Map.set(self, section, option, value)
	if type(value) ~= "table" or #value > 0 then
		if option then -- 设置option 有值；
			return self.uci:set(self.config, section, option, value)
		else -- 添加命名节区 namedsection
			return self.uci:set(self.config, section, value)
		end
	else -- 删除一个字段
		return Map.del(self, section, option)
	end
end

-- UCI del
function Map.del(self, section, option)
	if option then -- 删除一个字段
		return self.uci:delete(self.config, section, option)
	else -- 删除一个节区
		return self.uci:delete(self.config, section)
	end
end

-- UCI get
function Map.get(self, section, option)
	if not section then -- 整个配置文件
		return self.uci:get_all(self.config)
	elseif option then -- 指定字段
		return self.uci:get(self.config, section, option)
	else -- 指定节区
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
实例见: startup.lua 和 ipkg.lua
m = SimpleForm("initmgr", translate("Initscripts"), translate("You")
f = SimpleForm("rc", translate("Local Startup"),translate("This")
]]--

SimpleForm = class(Node)

function SimpleForm.__init__(self, config, title, description, data)
	Node.__init__(self, title, description)
	self.config = config      -- 字符串， /etc/config下配置文件名称
	self.data = data or {}
	self.template = "cbi/simpleform"  -- 关联 simpleform.htm
	self.dorender = true
	self.pageaction = false
	self.readinput = true -- true 从页面获得；否则返回false
end

SimpleForm.formvalue = Map.formvalue
SimpleForm.formvaluetable = Map.formvaluetable

function SimpleForm.parse(self, readinput, ...)
	self.readinput = (readinput ~= false) -- 默认输入为nil, 即self.readinput = true

	if self:formvalue("cbi.skip") then
		return FORM_SKIP
	end

	if self:formvalue("cbi.cancel") and self:_run_hooks("on_cancel") then
		return FORM_DONE
	end

	if self:submitstate() then -- SimpleForm.field 部分的处理
		Node.parse(self, 1, ...) -- 遍历children, 调用子节点的parse,子节点的readinput等于1
	end

	local valid = true
	for k, j in ipairs(self.children) do -- SimpleForm.section 部分的处理
		for i, v in ipairs(j.children) do -- section.option 部分的处理
			valid = valid -- 如果valid无效则直接返回；否则判断 缺失，无效，错误 的问题
			 and (not v.tag_missing or not v.tag_missing[1]) -- 如果valid有效则返回(not v.tag_missing or not v.tag_missing[1])
			 and (not v.tag_invalid or not v.tag_invalid[1]) -- 如果valid和(not v.tag_missing or not v.tag_missing[1])都有效
			 and (not v.error)       -- 否则返回(not v.error)
		end
	end

	local state =
		not self:submitstate() and FORM_NODATA -- 未提交返回 FORM_NODATA
		or valid and FORM_VALID -- 已提交，提交的有效返回 FORM_VALID
		or FORM_INVALID         -- 已提交，存在缺失，无效，错误则返回 FORM_INVALID

	self.dorender = not self.handle
	if self.handle then -- 存在handle函数时候，处理初始化时输入函数
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

-- 相当于map的Map.section
-- 使用方式  SimpleForm.section + SimpleSection
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
-- 相当于map的Map.section+AbstractSection.option；即可以直接到option
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
	if not section then -- 没有section会自动创建一个section
		section = self:section(SimpleSection)
	end

	if instanceof(class, AbstractValue) then -- 如果DummyValue是AbstractSection的实例
		local obj  = class(self, section, ...) -- 实例化DummyValue类
		obj.track_missing = true
		section:append(obj) -- 返回的obj追加给AbstractSection
		return obj -- 返回obj
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
	self.sectiontype = sectiontype  -- 字符串 当前section名字            节区名称
	self.map = map                  -- map实例
	-- map.proceed ； map.changed
	-- map:formvaluetable ； map:get(section) map:del(section)  map:set(section, nil, self.sectiontype) 
	-- map:add(self.sectiontype) map:set(section, v.option, v.default)
	self.config = map.config        -- config 字符串，当前config名字  文件名 或者字符串"table"表示表集合
	self.optionals = {} -- 由optional控制的节区，当optional=false时有效
	self.defaults = {}  -- 新建节区中字段的默认值
	self.fields = {}    -- table(k:string option的名字； v abstractvalue 实例)
	self.tag_error = {} -- 保存节区是否存在错误
	self.tag_invalid = {}  -- 保存节区是否存在invalid
	self.tag_deperror = {}
	self.changed = false

	self.optional = true
	self.addremove = false
	self.dynamic = false
end

-- Define a tab for the section tab="general" 内部使用， title="General Settings" 外部使用
--- s:tab("general",  translate("General Settings"))     增加general属性页
--- s:tab("logging",  translate("Logging"))              增加logging属性页
--- s:tab("language", translate("Language and Style"))   增加language属性页
function AbstractSection.tab(self, tab, title, desc)
	self.tabs      = self.tabs      or { } -- tab表，表保存成多个title,desc和childs信息
	self.tab_names = self.tab_names or { } -- 顺序保存tab表名

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
-- s:option(DummyValue, "index", translate("Start priority")) 非对应配置文件option的值
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

	if o then l[#l+1] = o end -- 追加到tabs[tab].childs表后

	return o
end

-- Render a single tab
function AbstractSection.render_tab(self, tab, ...)

	assert(tab and self.tabs and self.tabs[tab],
		"Cannot render not existing tab %q" % tostring(tab))

	local k, node
	for k, node in ipairs(self.tabs[tab].childs) do
		node.last_child = (k == #self.tabs[tab].childs) -- 当最后一个时，last_child = true
		node.index = k -- 记录option在tabsetion的位置
		node:render(...) -- 显示
	end
end

-- Parse optional options
-- load的时候被调用
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
-- 返回指定节区表(表中每个字段对应一个配置)
-- 如果section类型为table，则返回table的一条记录
function AbstractSection.cfgvalue(self, section)
	return self.map:get(section)
end

-- Push events
-- 通过AbstractValue通过AbstractSection,通过AbstractSection通知Map
function AbstractSection.push_events(self)
	--luci.util.append(self.map.events, self.events)
	self.map.changed = true
end

-- Removes the section
function AbstractSection.remove(self, section)
	self.map.proceed = true
	return self.map:del(section)
end

-- Creates the section 创建一个section
function AbstractSection.create(self, section)
	local stat

	if section then -- 创建一个命名section
		stat = section:match("^[%w_]+$") and self.map:set(section, nil, self.sectiontype)
	else -- 创建一个匿名section
		section = self.map:add(self.sectiontype)
		stat = section
	end

	if stat then
		for k,v in pairs(self.children) do -- 先配置选项自身的默认值
			if v.default then
				self.map:set(section, v.option, v.default)
			end
		end

		for k,v in pairs(self.defaults) do -- 再配置section自带defaults的默认k-v值
			self.map:set(section, k, v)
		end
	end

	self.map.proceed = true

	return stat
end


--[[
常用于Map下，用于插入一个独立的Section. 例如:dhcp.lua network.lua
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
常用于在SimpleForm.section()函数下面
展示非配置文件类型的数据集；例如startup.lua ipkg.lua等系统任务状态和包管理
startup.lua 用于管理开启启动
ipkg.lua    用于管理系统安装包
]]--

function Table.__init__(self, form, data, ...)
	local datasource = {}        -- 操作函数
	local tself = self
	datasource.config = "table"  -- 数据源类型
	self.data = data or {}       -- 数据集

	datasource.formvalue = Map.formvalue
	datasource.formvaluetable = Map.formvaluetable
	datasource.readinput = true

	-- 覆盖map提供的get, submitstate, del, get_scheme这几个函数，使得继承过来的
	-- cfgvalue, remove 等函授转变为对table的操作
	function datasource.get(self, section, option) -- 返回section表/section[option]字段的值
		return tself.data[section] and tself.data[section][option]
	end

	function datasource.submitstate(self) -- 返回"cbi.submit"参数的值
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

-- 返回数据索引表 即 k-v表中的k表， 只有Table和TypedSection有这个函数
function Table.cfgsections(self)
	local sections = {}

	for i, v in luci.util.kspairs(self.data) do
		table.insert(sections, i)
	end

	return sections
end

-- 更新当前数据
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

	if self.addremove then -- 能够添加删除section
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
			Node.parse(self, s) -- 递归调用children的parse
		end
		AbstractSection.parse_optionals(self, s)

		if self.changed then
			self:push_events()  -- Map.changed设置为true
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
-- 返回指定类型节区的索引表
function TypedSection.cfgsections(self)
	local sections = {}
	self.map.uci:foreach(self.map.config, self.sectiontype,
		function (section) -- checkscope在此就可以决定哪些section被显示，哪些不被显示
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
	if self.addremove then -- 配置可以增删选项时，才可以删除节区
		-- Remove
		-- form-data;name=\"cbi.rts.firewall.cfg2a3837\"
		-- cbi.rts.firewall.cfg283837 = 'Delete'
		local crval = REMOVE_PREFIX .. self.config
		local name = self.map:formvaluetable(crval)
		for k,v in pairs(name) do
			if k:sub(-2) == ".x" then
				k = k:sub(1, #k - 2)
			end -- k = cfg283837
			if self:cfgvalue(k) and self:checkscope(k) then -- checkscope在此进一步确定能否被删除
				self:remove(k)
			end
		end
	end

	local co -- 遍历所有字段
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
		if self.anonymous then -- 匿名
			if name then
				created = self:create(nil, origin)
			end
		else
			if name then
				-- Ignore if it already exists 同名冲突
				if self:cfgvalue(name) then
					name = nil;
				end

				name = self:checkscope(name)

				if not name then
					self.err_invalid = true
				end

				if name and #name > 0 then -- 创建命名
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

	if self.sortable then -- "cbi.sts." 此功能忽略
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
-- 实现过滤功能和option之间依赖功能
function TypedSection.checkscope(self, section)
	-- Check if we are not excluded
	-- 过滤功能
	if self.filter and not self:filter(section) then
		return nil
	end

	-- Check if at least one dependency is met
	-- options之间依赖功能
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

	-- validate 有效性检查
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
	self.section = section -- 字符串，当前section名字           节区名称
	self.option  = option  -- 字符串，当前option 名字           选项名字
	self.map     = map     -- Map 实例，
	--  Generates the unique CBID
	-- map:formvalue(key) ； map.save = false； map:get(section, self.option)  
	-- map:set(section, self.option, value) ； map:del(section, self.option)
	self.config  = map.config -- config 字符串，当前config名字  文件名
	self.tag_invalid = {} -- 无效表
	self.tag_missing = {} -- 缺失表
	self.tag_reqerror = {} -- 请求错误表
	self.tag_error = {}    -- 错误表
	self.deps = {} -- 依赖其他option
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
-- DynamicList.depends("enable", "1")  system.lua中ntp server配置依赖系统使能ntpclient客户端
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
-- name=cbid 同时 id=cbid; 即: cbid是字段级别的，配置文件的所有选项都在页面由唯一cbid进行索引
-- cbid函数通过section参数来限定。参数化之后就增加设计灵活性；
function AbstractValue.cbid(self, section)
	return "cbid."..self.map.config.."."..section.."."..self.option
end

-- Return whether this object should be created
-- 获取 cbi.opt.${config}.${section} 对应的值 
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

-- 强制的; 命令的; 受委托的
function AbstractValue.mandatory(self, value)
	self.rmempty = not value
end

-- 
function AbstractValue.add_error(self, section, type, msg)
	self.error = self.error or { }
	self.error[section] = msg or type -- 自身记录错误内容

	self.section.error = self.section.error or { }
	self.section.error[section] = self.section.error[section] or { }
	table.insert(self.section.error[section], msg or type) -- section 记录错误内容

	if type == "invalid" then
		self.tag_invalid[section] = true -- 记录标签无效
	elseif type == "missing" then
		self.tag_missing[section] = true -- 记录标签缺失
	end

	self.tag_error[section] = true -- 记录标签错误
	self.map.save = false  -- map 提交错误，不能保存
end

-- novld 表示不能是无效的获取值
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

		if not fvalue and not novld then -- 提交给服务器数据不能要求
			self:add_error(section, "invalid", val_err)
		end

		if fvalue and (self.forcewrite or not (fvalue == cvalue)) then -- 如果强制write，那么即使fvalue == cvalue也写入
			if self:write(section, fvalue) then
				-- Push events
				self.section.changed = true
				--luci.util.append(self.map.events, self.events)
			end
		end
	else							-- Unset the UCI or error
		if self.rmempty or self.optional then
			if self:remove(section) then -- 删除节区
				-- Push events
				self.section.changed = true
				--luci.util.append(self.map.events, self.events)
			end
		elseif cvalue ~= fvalue and not novld then -- 缺失一些内容，不能正常处理
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
-- 返回AbstractValue关联的值，先从web页面获取，否则从配置文件获取；
-- 返回值有nil, string, table
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
--- function Value.write(self, section, value)  见system.lua
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
	
1. 可以修改内容的填入框
2. 不可以修改内容的填入框
3. 具有下拉功能的填入框
4. password密码输入框

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
	self.keylist = {}    -- 关键字选项
	self.vallist = {}    -- 关键字值选项
	self.readonly = nil  -- 只读选项
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
	if self.readonly then return end -- 只读选项
	AbstractValue.parse(self, section, novld)
end

-- DummyValue - This does nothing except being there
DummyValue = class(AbstractValue)

--[[
1. 与Table一起使用，显示表格中内容
2. 与Section一起使用，显示表格中内容, 如forward集中显示多个配置内容的值
]]--

--- o.template = "admin_system/clock_status"  见 system.lua 中，修改显示template
function DummyValue.__init__(self, ...)
	AbstractValue.__init__(self, ...)
	self.template = "cbi/dvalue" -- 这句话o.template调用template/cbi/dvalue.htm文件
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
常用于功能的开启和关闭；即对勾是开启，空白是不开启
NamedSection:option(Value, ''option'', ''title'', ''description'')
TypedSection:option(Value, ''option'', ''title'', ''description'')
]]--
Flag = class(AbstractValue)

function Flag.__init__(self, ...)
	AbstractValue.__init__(self, ...)
	self.template  = "cbi/fvalue"

	self.enabled  = "1"  -- 使能默认值
	self.disabled = "0"  -- 不是能默认值
	self.default  = self.disabled -- 默认值
end

-- A flag can only have two states: set or unset
function Flag.parse(self, section, novld)
	local fexists = self.map:formvalue(
		FEXIST_PREFIX .. self.config .. "." .. section .. "." .. self.option)

	if fexists then
		local fvalue = self:formvalue(section) and self.enabled or self.disabled -- 有值则是使能，否则是不使能
		local cvalue = self:cfgvalue(section)
		local val_err
		fvalue, val_err = self:validate(fvalue, section)
		if not fvalue then
			if not novld then
				self:add_error(section, "invalid", val_err)
			end
			return
		end
		-- 页面配置值等于默认值，且该对象 optional 或 rmempty 任意为true， 则删除配置内容
		if fvalue == self.default and (self.optional or self.rmempty) then
			self:remove(section)
		else
			self:write(section, fvalue)
		end
		-- fvalue ~= cvalue 则 节区发生变化
		if (fvalue ~= cvalue) then self.section.changed = true end
	else
		self:remove(section)
		self.section.changed = true
	end
end

function Flag.cfgvalue(self, section) -- 配置文件没值则返回默认值
	return AbstractValue.cfgvalue(self, section) or self.default
end
function Flag.validate(self, value)
	return value
end

--[[
ListValue - A one-line value predefined in a list
	widget: The widget that will be used (select, radio)
简单的下拉菜单； 见 forward.lua
NamedSection:option(Value, ''option'', ''title'', ''description'')
TypedSection:option(Value, ''option'', ''title'', ''description'')
]]--
ListValue = class(AbstractValue)

--- 常常重构 function ListValue.write(self, section, value)
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
-- ListValue:value("UTC")  下拉列表选择项
-- for i, zone in ipairs(zones.TZ) do
-- 	ListValue:value(zone[1]) 
-- end
function ListValue.value(self, key, val, ...)       -- 添加下拉选项
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
1. 可以有很多选项被同时选定; 多个选项平铺显示而不是下拉显示 有select 和 checkbox两种样式
]]--
MultiValue = class(AbstractValue)

function MultiValue.__init__(self, ...)
	AbstractValue.__init__(self, ...)
	self.template = "cbi/mvalue"

	self.widget = "checkbox"
	self.delimiter = " "  -- 分隔符

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
 很少用，忽略
]]--
StaticList = class(MultiValue)

function StaticList.__init__(self, ...)
	MultiValue.__init__(self, ...)
	self.cast = "table" -- 返回table值
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
用于时间服务器类型字段，list类型
]]--
DynamicList = class(AbstractValue)

-- o = s:option(DynamicList, "server", translate("NTP server candidates")) /etc/config/system中list表示方式
function DynamicList.__init__(self, ...)
	AbstractValue.__init__(self, ...)
	self.template  = "cbi/dynlist"
	self.cast = "table"  -- 返回table值
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
常用于文件输入，该文件可以修改启动顺序，配置em350参数等等
]]--
TextValue = class(AbstractValue)

function TextValue.__init__(self, ...)
	AbstractValue.__init__(self, ...)
	self.template  = "cbi/tvalue"
end

--[[
Button
常用于功能的开启和关闭；点击一次是开启，那么再次点击就是关闭。
在startup中，有很好的实例；
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
