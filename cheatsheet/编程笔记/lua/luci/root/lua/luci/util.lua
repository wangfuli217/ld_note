-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Licensed to the public under the Apache License 2.0.

local io = require "io"
local math = require "math"
local table = require "table"
local debug = require "debug"
local ldebug = require "luci.debug"
local string = require "string"
local coroutine = require "coroutine"
local tparser = require "luci.template.parser"
local json = require "luci.jsonc"

local _ubus = require "ubus"
local _ubus_connection = nil

local getmetatable, setmetatable = getmetatable, setmetatable
local rawget, rawset, unpack = rawget, rawset, unpack
local tostring, type, assert, error = tostring, type, assert, error
local ipairs, pairs, next, loadstring = ipairs, pairs, next, loadstring
local require, pcall, xpcall = require, pcall, xpcall
local collectgarbage, get_memory_limit = collectgarbage, get_memory_limit

module "luci.util"

--
-- Pythonic string formatting extension
-- Python 方式的字符串 格式化扩展
--
getmetatable("").__mod = function(a, b)
	local ok, res

	if not b then
		return a
	elseif type(b) == "table" then
		local k, _
		for k, _ in pairs(b) do if type(b[k]) == "userdata" then b[k] = tostring(b[k]) end end

		ok, res = pcall(a.format, a, unpack(b))
		if not ok then
			error(res, 2)
		end
		return res
	else
		if type(b) == "userdata" then b = tostring(b) end

		ok, res = pcall(a.format, a, b)
		if not ok then
			error(res, 2)
		end
		return res
	end
end


--
-- Class helper routines
--

-- Instantiates a class 实例一个类
local function _instantiate(class, ...)
	local inst = setmetatable({}, {__index = class}) -- 这个元表用于存储ipt实例的数据
-- inst 表的元表内__index存储了IptParser.func声明的函数
-- 也就是说inst查找自身func不存在的时候，会跳到元表class(IptParser)声明的func上
-- ":"定义的函数比"."定义的函数多了一个self的隐藏形参，并且是作为第一个隐藏形参
	if inst.__init__ then
		inst:__init__(...)
	end

	return inst
end

-- The class object can be instantiated by calling itself.
-- Any class functions or shared parameters can be attached to this object.
-- Attaching a table to the class object makes this table shared between
-- all instances of this class. For object parameters use the __init__ function.
-- Classes can inherit member functions and values from a base class.
-- Class can be instantiated by calling them. All parameters will be passed
-- to the __init__ function of this class - if such a function exists.
-- The __init__ function must be used to set any object parameters that are not shared
-- with other objects of this class. Any return values will be ignored.

-- Local class= util.class   class()函数return setmetatable({}, {__call = _instantiate,__index = base)}  
-- 当调用的时候，调用_instantiate(class, ...),函数中调用inst:__init__(...)函数初始化具体的类,返回类。
--
-- lua -l luci.sys -e 'ipt = require "luci.sys.iptparser".IptParser for k, v in pairs(ipt) do print(k, v) end '
-- lua -l luci.sys -e 'ipt = require "luci.sys.iptparser".IptParser() for k, v in pairs(getmetatable(ipt).__index) do print(k, v) end '
-- 所有的函数位于元表的__index 指向的表内
-- 这个是个声明
-- lua -l luci.sys -e 'ipt = require "luci.sys.iptparser".IptParser() for k, v in pairs(ipt) do print(k, v) end '
-- 所有的数据位于表自身
-- self表对象自身，冒号可以省略self
-- 这个是个实现

--- 返回一个表，没有省略参数base则为nil,
-- + Create a Class object (Python-style object model).
-- # base: The base class to inherit from (optional)
-- $ A class object
function class(base)           -- base 是基类table，没有作为参数传递，base值就位nil
	return setmetatable({}, {  -- 这个元表用于存储IptParser实例的函数
		__call  = _instantiate,
		__index = base
	})
end

-- IptParser = luci.util.class()            用一个table表示类型，table的函数为成员函数，table的字段为类型成员变量
-- ipt = luci.sys.iptparser.IptParser(mode) 用一个table表示实例，ipt的成员函数为IptParser的成员函数, ipt的成员变量为self的成员变量


-- object table作为实现table的实例，存在self特性的成员变量
-- class  table作为object的元表
-- + Test whether the given object is an instance of the given class.
-- # object: Object instance
-- # class: Class object to test against
-- $ Boolean indicating whether the object is an instance
function instanceof(object, class)
	local meta = getmetatable(object)  -- 首次
	while meta and meta.__index do
		if meta.__index == class then
			return true
		end
		meta = getmetatable(meta.__index) -- 遍历次
	end
	return false
end


--
-- Scope manipulation routines
--

-- coroutine.running() 返回正在运行的协程，如果在主协程中调用，则此函数返回nil
local tl_meta = {
	__mode = "k",

	__index = function(self, key)
		local t = rawget(self, coxpt[coroutine.running()] -- 获取表self关联的表
		 or coroutine.running() or 0)
		return t and t[key] -- 返回为running返回状态值
	end,

	__newindex = function(self, key, value) -- 新建一个值，或者赋值给存在键
		local c = coxpt[coroutine.running()] or coroutine.running() or 0
		local r = rawget(self, c)
		if not r then
			rawset(self, c, { [key] = value })
		else
			r[key] = value
		end
	end
}

-- the current active coroutine. A thread local store is private a table object
-- whose values can't be accessed from outside of the running coroutine.
-- 使用元表实现协程上下文表
-- 获得与协程关联的数据 -- 私有数据
-- + Create a new or get an already existing thread local store associated with the current active coroutine
-- $ Table value representing the corresponding thread local store
function threadlocal(tbl)
	return setmetatable(tbl or {}, tl_meta)
end


--
-- Debugging routines
-- 可用于lua -i -l util -l sys交互验证的时候 debug
--

-- 错误输出到前台
-- + Write given object to stderr.
-- # obj: Value to write to stderr
-- $ Boolean indicating whether the write operation was successful
function perror(obj)
	return io.stderr:write(tostring(obj) .. "\n")
end

-- 输出table类型对象
-- t         需要输出table
-- maxdepth  table 输出表深度
-- i         当前表深度
-- seen      用于判断此表是否已经输出过
-- + Recursively dumps a table to stdout, useful for testing and debugging.
-- # t: Table value to dump
-- # maxdepth: Maximum depth
-- $ Always nil
function dumptable(t, maxdepth, i, seen)
	i = i or 0
	seen = seen or setmetatable({}, {__mode="k"})

	for k,v in pairs(t) do
		perror(string.rep("\t", i) .. tostring(k) .. "\t" .. tostring(v))
		if type(v) == "table" and (not maxdepth or i < maxdepth) then
			if not seen[v] then
				seen[v] = true
				dumptable(v, maxdepth, i+1, seen)
			else
				perror(string.rep("\t", i) .. "*** RECURSION ***") -- t中元素或子元素已经输出过，再次输出就递归输出了
			end
		end
	end
end


--
-- String and data manipulation routines
--

-- Create valid XML PCDATA from given string.
-- value: String value containing the data to escape
-- PCDATA 被解析的字符数据 (Parsed Character Data)
-- <name><first>Bill</first><last>Gates</last></name> -> &#60;name&#62;&#60;first&#62;Bill&#60;/first&#62;&#60;last&#62;Gates&#60;/last&#62;&#60;/name&#62;
-- + Create valid XML PCDATA from given string.
-- # value: String value containing the data to escape
-- $ String value containing the escaped data
function pcdata(value)
	return value and tparser.pcdata(tostring(value))
end

-- Strip HTML tags from given string.
-- value: String containing the HTML text
-- "<name><first>Bill</first><last>Gates</last></name>" -> Bill Gates
-- + Strip HTML tags from given string.
-- # value: String containing the HTML text
-- $ String with HTML tags stripped of
function striptags(value)
	return value and tparser.striptags(tostring(value))
end

-- 转义 -- 对单引号字符串按照字面形式输出
-- for bash, ash and similar shells single-quoted strings are taken
-- literally except for single quotes (which terminate the string)
-- (and the exception noted below for dash (-) at the start of a
-- command line parameter).
-- "'<name><first>Bill</first><last>Gates</last></name>'" -> '\''<name><first>Bill</first><last>Gates</last></name>'\''
function shellsqescape(value)
   local res
   res, _ = string.gsub(value, "'", "'\\''") -- ' -> \'
   return res
end

-- 转义 -- 将-作为参数选项解析 见fstab.lua
-- bash, ash and other similar shells interpret a dash (-) at the start
-- of a command-line parameters as an option indicator regardless of
-- whether it is inside a single-quoted string.  It must be backlash
-- escaped to resolve this.  This requires in some funky special-case
-- handling.  It may actually be a property of the getopt function
-- rather than the shell proper.
function shellstartsqescape(value)
   res, _ = string.gsub(value, "^\-", "\\-") -- ^\- -> \-'
   res, _ = string.gsub(res, "^-", "\-")     -- ^-  -> \-
   return shellsqescape(value)
end

-- containing the resulting substrings. The optional max parameter specifies
-- the number of bytes to process, regardless of the actual length of the given
-- string. The optional last parameter, regex, specifies whether the separator
-- sequence is interpreted as regular expression.
--					pattern as regular expression (optional, default is false)
-- str 带分割的字符串   字符串
-- pat 分隔符           模式匹配|字面匹配字符串    默认值是换行
-- max 最大长度         符合匹配的最大个数         默认值是字符串长度
-- regex 模式;          true模式匹配 false字面匹配 默认值是字面匹配
-- 返回值: 有pat分割的str序列

-- split(str)           按行分割，返回行字符串表
-- split(str, pat)      最多返回字符串长度个数表元素
-- split(str, pat, max) 最多返回max个表元素
-- split(str, pat, max, true) true 模式匹配|false 字面匹配
-- luci.util.split( rule, "%s+", nil, true )
-- + Splits given string on a defined separator sequence and return a table containing the resulting substrings.
-- # str: String value containing the data to split up
-- # pat: String with separator pattern (optional, defaults to "\n")
-- # max: Maximum times to split (optional)
-- # regex: Boolean indicating whether to interpret the separator pattern as regular expression (optional, default is false)
-- $ Table containing the resulting substrings
function split(str, pat, max, regex)
	pat = pat or "\n"
	max = max or #str

	local t = {}
	local c = 1

	if #str == 0 then
		return {""}
	end

	if #pat == 0 then
		return nil
	end

	if max == 0 then
		return str
	end

	repeat
		local s, e = str:find(pat, c, not regex) -- true 字面匹配 false 模式匹配
		max = max - 1
		if s and max < 0 then
			t[#t+1] = str:sub(c)
		else
			t[#t+1] = str:sub(c, s and s - 1)
		end
		c = e and e + 1 or #str + 1
	until not s or max < 0

	return t
end

-- %s 表示空白字符，命令为删除字符串开头和结尾的空格
-- + Remove leading and trailing whitespace from given string value.
-- # str: String value containing whitespace padded data
-- $ String value with leading and trailing space remove
function trim(str)
	return (str:gsub("^%s*(.-)%s*$", "%1")) -- 将匹配零个或更多个该类的字符，这个条目总是尽可能短匹配
end

-- count match 计算模式匹配的次数
-- str 字符串
-- pat 模式匹配内容
-- + Count the occurrences of given substring in given string.
-- # str: String to search in
-- # pattern: String containing pattern to find
-- $ Number of found occurrences
function cmatch(str, pat)
	local count = 0
	for _ in str:gmatch(pat) do count = count + 1 end
	return count
end

-- one token per invocation, the tokens are separated by whitespace. If the
-- input value is a table, it is transformed into a string first. A nil value
-- will result in a valid interator which aborts with the first invocation.
---- 迭代生成器
-- table 遍历table的每个元素
-- number或者boolean    返回数字
-- userdata或者string则 返回组成字符串的单词
-- + Return a matching iterator for the given value.
-- # val: The value to scan (table, string or nil)
-- $ Iterator which returns one token per call
function imatch(v)
	if type(v) == "table" then
		local k = nil
		return function() -- 闭包函数
			k = next(v, k)
			return v[k]
		end

	elseif type(v) == "number" or type(v) == "boolean" then
		local x = true
		return function() -- 闭包函数
			if x then
				x = false
				return tostring(v)
			end
		end

	elseif type(v) == "userdata" or type(v) == "string" then -- 按空白分割的单词
		return tostring(v):gmatch("%S+") -- gmatch自身就是个迭代器
	end

	return function() end -- 空闭包函数
end

-- irrelevant 不相干的
-- value or 0 if the unit is unknown. Upper- or lower case is irrelevant.
-- Recognized units are:
--	o "y"	- one year   (60*60*24*366)
--  o "m"	- one month  (60*60*24*31)
--  o "w"	- one week   (60*60*24*7)
--  o "d"	- one day    (60*60*24)
--  o "h"	- one hour	 (60*60)
--  o "min"	- one minute (60)
--  o "kb"  - one kilobyte (1024)
--  o "mb"	- one megabyte (1024*1024)
--  o "gb"	- one gigabyte (1024*1024*1024)
--  o "kib" - one si kilobyte (1000)
--  o "mib"	- one si megabyte (1000*1000)
--  o "gib"	- one si gigabyte (1000*1000*1000)

-- str = parse_units("2017y")    63811843200
-- str = parse_units("2017y11m") 63782380800
-- + Parse certain units from the given string and return the canonical integer value or 0 if the unit is unknown.
-- # ustr: String containing a numerical value with trailing unit
-- $ Number containing the canonical value
function parse_units(ustr)

	local val = 0

	-- unit map
	local map = {
		-- date stuff
		y   = 60 * 60 * 24 * 366,
		m   = 60 * 60 * 24 * 31,
		w   = 60 * 60 * 24 * 7,
		d   = 60 * 60 * 24,
		h   = 60 * 60,
		min = 60,

		-- storage sizes
		kb  = 1024,
		mb  = 1024 * 1024,
		gb  = 1024 * 1024 * 1024,

		-- storage sizes (si)
		kib = 1000,
		mib = 1000 * 1000,
		gib = 1000 * 1000 * 1000
	}

	-- parse input string
	for spec in ustr:lower():gmatch("[0-9%.]+[a-zA-Z]*") do

		local num = spec:gsub("[^0-9%.]+$","")
		local spn = spec:gsub("^[0-9%.]+", "")

		if map[spn] or map[spn:sub(1,1)] then
			val = val + num * ( map[spn] or map[spn:sub(1,1)] )
		else
			val = val + num
		end
	end


	return val
end

-- also register functions above in the central string class for convenience
string.pcdata      = pcdata
string.striptags   = striptags
string.split       = split
string.trim        = trim
string.cmatch      = cmatch
string.parse_units = parse_units

-- 将后续元素放到src表后面; 追加类型是表则合并表；追加类型是其他类型，则尾部追加
-- + Appends numerically indexed tables or single objects to a given table.
-- # src: Target table 
-- # ...: Objects to insert
-- $ Target table
function append(src, ...)
	for i, a in ipairs({...}) do
		if type(a) == "table" then  -- 不处理迭代
			for j, v in ipairs(a) do
				src[#src+1] = v
			end
		else
			src[#src+1] = a
		end
	end
	return src
end

-- 合并后续元素为一个表； 将参数化元素合并到list类型的table中返回
-- - combine (tbl1, tbl2, ...)
-- + Combines two or more numerically indexed tables and single objects into one table.
-- # tbl1: Table value to combine
-- # tbl2: Table value to combine
-- # ...: More tables to combine
-- $ Table value containing all values of given tables
function combine(...)
	return append({}, ...)
end

-- 查找表是否包含指定元素 ； 表中是否包含value判断, 只进行一层比较，不再进行表-表的元素判断
-- + Checks whether the given table contains the given value.
-- # table: Table value
-- # value: Value to search within the given table
-- $ Number indicating the first index at which the given value occurs within table or false.
function contains(table, value)
	for k, v in pairs(table) do
		if value == v then
			return k
		end
	end
	return false
end

-- 将updates表内的元素合并到t表中
-- Both table are - in fact - merged together.
-- + Update values in given table with the values from the second given table.
-- # t: Table which should be updated
-- # updates: Table containing the values to update
-- $ Always nil
function update(t, updates)
	for k, v in pairs(updates) do
		t[k] = v
	end
end

-- 返回t中所有keys；keys为有序集合
-- + Retrieve all keys of given associative table.
-- # t: Table to extract keys from
-- $ Sorted table containing the keys
function keys(t)
	local keys = { }
	if t then
		for k, _ in kspairs(t) do
			keys[#keys+1] = k
		end
	end
	return keys
end

-- 克隆 {深度拷贝}
-- + Clones the given object and return it's copy.
-- # object: Table value to clone
-- # deep: Boolean indicating whether to do recursive cloning
-- $ Cloned table value
function clone(object, deep)
	local copy = {}

	for k, v in pairs(object) do
		if deep and type(v) == "table" then
			v = clone(v, deep)
		end
		copy[k] = v
	end

	return setmetatable(copy, getmetatable(object))
end

-- 获取的key不存在时，返回一个dtable()
-- + 
function dtable()
        return setmetatable({}, { __index =
                function(tbl, key)
                        return rawget(tbl, key)
                         or rawget(rawset(tbl, key, dtable()), key)
                end
        })
end


-- Serialize the contents of a table value.
-- 
function _serialize_table(t, seen)
	assert(not seen[t], "Recursion detected.")
	seen[t] = true

	local data  = ""
	local idata = ""
	local ilen  = 0

	for k, v in pairs(t) do -- 字典表
		if type(k) ~= "number" or k < 1 or math.floor(k) ~= k or ( k - #t ) > 3 then
			k = serialize_data(k, seen)
			v = serialize_data(v, seen)
			data = data .. ( #data > 0 and ", " or "" ) ..
				'[' .. k .. '] = ' .. v
		elseif k > ilen then
			ilen = k
		end
	end

	for i = 1, ilen do  -- 序列表
		local v = serialize_data(t[i], seen)
		idata = idata .. ( #idata > 0 and ", " or "" ) .. v
	end

	return idata .. ( #data > 0 and #idata > 0 and ", " or "" ) .. data
end

-- with loadstring().
-- 返回变量的代码源义: 即可以将返回值作为标准赋值部分
-- + Recursively serialize given data to lua code, suitable for restoring with loadstring().
-- # val: Value containing the data to serialize
-- $ String value containing the serialized code
function serialize_data(val, seen)
	seen = seen or setmetatable({}, {__mode="k"})

	if val == nil then
		return "nil"
	elseif type(val) == "number" then
		return val
	elseif type(val) == "string" then
		return "%q" % val
	elseif type(val) == "boolean" then
		return val and "true" or "false"
	elseif type(val) == "function" then
		return "loadstring(%q)" % get_bytecode(val) -- 接受一个字符串并将其转化为可安全被Lua编译器读入的格式
	elseif type(val) == "table" then
		return "{ " .. _serialize_table(val, seen) .. " }"
	else
		return '"[unhandled data type:' .. type(val) .. ']"'
	end
end

-- 加载可执行字符串
-- + Restore data previously serialized with serialize_data().
-- # str: String containing the data to restore
-- $ Value containing the restored data structure
function restore_data(str)
	return loadstring("return " .. str)()
end


--
-- Byte code manipulation routines
--

-- will be stripped before it is returned.
-- val 可以是一个函数引用
-- val 也可以是包含函数code的字符串
-- + Return the current runtime bytecode of the given data. The byte code will be stripped before it is returned.
-- # val: Value to return as bytecode
-- $ String value containing the bytecode of the given data
function get_bytecode(val)
	local code

	if type(val) == "function" then
		code = string.dump(val) -- 返回指定函数的二进制代码
	else
		code = string.dump( loadstring( "return " .. serialize_data(val) ) )
	end

	return code -- and strip_bytecode(code)
end

-- numbers and debugging numbers will be discarded. Original version by
-- Peter Cawley (http://lua-users.org/lists/lua-l/2008-02/msg01158.html)
-- + Strips unnescessary lua bytecode from given string.
-- # code: String value containing the original lua byte code
-- $ String value containing the stripped lua byte code
function strip_bytecode(code)
	local version, format, endian, int, size, ins, num, lnum = code:byte(5, 12)
	local subint
	if endian == 1 then
		subint = function(code, i, l)
			local val = 0
			for n = l, 1, -1 do
				val = val * 256 + code:byte(i + n - 1)
			end
			return val, i + l
		end
	else
		subint = function(code, i, l)
			local val = 0
			for n = 1, l, 1 do
				val = val * 256 + code:byte(i + n - 1)
			end
			return val, i + l
		end
	end

	local function strip_function(code)
		local count, offset = subint(code, 1, size)
		local stripped = { string.rep("\0", size) }
		local dirty = offset + count
		offset = offset + count + int * 2 + 4
		offset = offset + int + subint(code, offset, int) * ins
		count, offset = subint(code, offset, int)
		for n = 1, count do
			local t
			t, offset = subint(code, offset, 1)
			if t == 1 then
				offset = offset + 1
			elseif t == 4 then
				offset = offset + size + subint(code, offset, size)
			elseif t == 3 then
				offset = offset + num
			elseif t == 254 or t == 9 then
				offset = offset + lnum
			end
		end
		count, offset = subint(code, offset, int)
		stripped[#stripped+1] = code:sub(dirty, offset - 1)
		for n = 1, count do
			local proto, off = strip_function(code:sub(offset, -1))
			stripped[#stripped+1] = proto
			offset = offset + off - 1
		end
		offset = offset + subint(code, offset, int) * int + int
		count, offset = subint(code, offset, int)
		for n = 1, count do
			offset = offset + subint(code, offset, size) + size + int * 2
		end
		count, offset = subint(code, offset, int)
		for n = 1, count do
			offset = offset + subint(code, offset, size) + size
		end
		stripped[#stripped+1] = string.rep("\0", int * 3)
		return table.concat(stripped), offset
	end

	return code:sub(1,12) .. strip_function(code:sub(13,-1))
end


--
-- Sorting iterator functions
--
-- 基于函数f的，有序迭代器； 迭代器返回 k,v和pos三个值
function _sortiter( t, f )
	local keys = { }

	local k, v
	for k, v in pairs(t) do
		keys[#keys+1] = k
	end

	local _pos = 0

	table.sort( keys, f )

	return function()
		_pos = _pos + 1 -- _pos 作为闭包函数内部变量， keys也作为闭包函数内部table
		if _pos <= #keys then
			return keys[_pos], t[keys[_pos]], _pos -- 返回k, v 和 pos三个值
		end
	end
end

-- the provided callback function.
-- 对_sortiter的一次封装
-- + Return a key, value iterator which returns the values sorted according to the provided callback function.
-- # t: The table to iterate
-- # f: A callback function to decide the order of elements
-- $ Function value containing the corresponding iterator
function spairs(t,f)
	return _sortiter( t, f )
end

-- The table pairs are sorted by key.
-- key集合: 基于字母顺序的迭代器
-- + Return a key, value iterator for the given table.
-- # t: The table to iterate
-- $ Function value containing the corresponding iterator
function kspairs(t)
	return _sortiter( t )
end

-- The table pairs are sorted by value.
-- value集合: 基于字母顺序的和数字大小的迭代器
-- + Return a key, value iterator for the given table.
-- # t: The table to iterate
-- $ Function value containing the corresponding iterator
function vspairs(t)
	return _sortiter( t, function (a,b) return t[a] < t[b] end )
end


--
-- System utility functions
--
-- 在x86上等于1
-- + Test whether the current system is operating in big endian mode.
function bigendian()
	return string.byte(string.dump(function() end), 7) == 0
end

-- 执行命令返回所有数据
-- + Execute given commandline and gather stdout.
-- $ Boolean value indicating whether system is big endian
-- # command: String containing command to execute
-- $ String containing the command's stdout
function exec(command)
	local pp   = io.popen(command)
	local data = pp:read("*a")
	pp:close()

	return data
end

-- 执行命令返回数据行迭代器
-- + Return a line-buffered iterator over the output of given command.
-- # command: String containing command to execute
-- $ Iterator
function execi(command)
	local pp = io.popen(command)

	return pp and function()
		local line = pp:read()

		if not line then
			pp:close()
		end

		return line
	end
end

-- 执行命令返回所有数据存在表中
-- Deprecated
function execl(command)
	local pp   = io.popen(command)
	local line = ""
	local data = {}

	while true do
		line = pp:read()
		if (line == nil) then break end
		data[#data+1] = line
	end
	pp:close()

	return data
end

-- ubus命令
-- command : ubus call session list
-- command : ubus call session get  '{"ubus_rpc_session": "fb7b64671e5c55dca32910663b2b7b31" }' 
-- lua     : sdata = luci.util.ubus("session", "get", {ubus_rpc_session="fb7b64671e5c55dca32910663b2b7b31" })
-- lua     : sdata = luci.util.ubus("service", "list", {})
-- lua     : luci.util.dumptable(sdata)
-- + Issue an ubus call.
-- # object: String containing the ubus object to call
-- # method: String containing the ubus method to call
-- # values: Table containing the values to pass
-- $ Table containin the ubus result
function ubus(object, method, data)
	if not _ubus_connection then
		_ubus_connection = _ubus.connect()
		assert(_ubus_connection, "Unable to establish ubus connection")
	end

	if object and method then
		if type(data) ~= "table" then
			data = { }
		end
		return _ubus_connection:call(object, method, data)
	elseif object then
		return _ubus_connection:signatures(object)
	else
		return _ubus_connection:objects()
	end
end

-- 将 table 字符串 lua类型进行序列化成json格式
-- luatbl={ label = { choose = '-- Please choose --', custom = '-- custom --', },
--          path = {  resource = resource, browser  = "admin/filebrowser" } }
-- 输出 {"path":{"browser":"admin/filebrowser"},"label":{"choose":"-- Please choose --","custom":"-- custom --"}}\
-- + Convert data structure to JSON
-- # data: The data to serialize
-- # writer: A function to write a chunk of JSON data (optional)
-- $ String containing the JSON if called without write callback
function serialize_json(x, cb)
	local js = json.stringify(x)
	if type(cb) == "function" then
		cb(js)
	else
		return js
	end
end

-- /usr/lib/lua/luci 返回该值
-- + Returns the absolute path to LuCI base directory.
-- $ String containing the directory path
function libpath()
	return require "nixio.fs".dirname(ldebug.__file__) -- 
end

-- have_dnssec_support = luci.util.checklib("/usr/sbin/dnsmasq", "libhogweed.so")
function checklib(fullpathexe, wantedlib)
	local fs = require "nixio.fs"
	local haveldd = fs.access('/usr/bin/ldd')
	if not haveldd then
		return false
	end
	local libs = exec("/usr/bin/ldd " .. fullpathexe)
	if not libs then
		return false
	end
	for k, v in ipairs(split(libs)) do
		if v:find(wantedlib) then
			return true
		end
	end
	return false
end

--
-- Coroutine safe xpcall and pcall versions modified for Luci
-- original version:
-- coxpcall 1.13 - Copyright 2005 - Kepler Project (www.keplerproject.org)
--
-- Copyright 漏 2005 Kepler Project.
-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the "Software"),
-- to deal in the Software without restriction, including without limitation
-- the rights to use, copy, modify, merge, publish, distribute, sublicense,
-- and/or sell copies of the Software, and to permit persons to whom the
-- Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
-- OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
-- DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
-- TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
-- OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

local performResume, handleReturnValue
local oldpcall, oldxpcall = pcall, xpcall
coxpt = {}
setmetatable(coxpt, {__mode = "kv"})

-- Identity function for copcall
local function copcall_id(trace, ...)
  return ...
end

--				values of either the function or the error handler
-- + This is a coroutine-safe drop-in replacement for Lua's "xpcall"-function
-- # f: Lua function to be called protected
-- # err: Custom error handler
-- # ...: Parameters passed to the function
-- $ A boolean whether the function call succeeded and the return values of either the function or the error handler
function coxpcall(f, err, ...)
	local res, co = oldpcall(coroutine.create, f)
	if not res then
		local params = {...}
		local newf = function() return f(unpack(params)) end
		co = coroutine.create(newf)
	end
	local c = coroutine.running() -- 返回当前的协程,如果是在主线程,则返回nil
	coxpt[co] = coxpt[c] or c or 0 -- co 为新建协程引用，c为当前协程引用
	-- 将子协程和主协程之间的关联关系存储到coxpt表中，关联关系是协程引用

	return performResume(err, co, ...)
end

-- values of the function or the error object
-- + This is a coroutine-safe drop-in replacement for Lua's "pcall"-function
-- # f: Lua function to be called protected
-- # ... Parameters passed to the function
-- $ A boolean whether the function call succeeded and the returns values of the function or the error object
function copcall(f, ...)
	return coxpcall(f, copcall_id, ...)
end

-- Handle return value of protected call
function handleReturnValue(err, co, status, ...)
	if not status then
		return false, err(debug.traceback(co, (...)), ...) -- 执行后，出现错误 
	end

	if coroutine.status(co) ~= 'suspended' then -- 没有处在suspended状态则退出
		return true, ...  -- 不受coroutine.yeild() 退出影响，需要再次调用coroutine.resume
	end

	return performResume(err, co, coroutine.yield(...)) -- 
end

-- Resume execution of protected function call
function performResume(err, co, ...)
	return handleReturnValue(err, co, coroutine.resume(co, ...))
end

-- handleReturnValue <-> performResume [ coroutine.yield(...) <-> coroutine.resume(co, ...) ]
-- 1. 错误退出递归
-- 2. 状态不等于suspended 退出递归 (normal, running)