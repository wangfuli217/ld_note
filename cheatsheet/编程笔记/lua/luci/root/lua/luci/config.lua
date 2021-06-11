-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Licensed to the public under the Apache License 2.0.

local util = require "luci.util"
module("luci.config",  -- 如果luci.config存在则返回自身内容，否则返回luci.model.uci.cursor()中get_all获得内容
		function(m)
			if pcall(require, "luci.model.uci") then
				local config = util.threadlocal()
				setmetatable(m, {
					__index = function(tbl, key) -- 变量不再情况下的，变量默认值
						if not config[key] then
							config[key] = luci.model.uci.cursor():get_all("luci", key)
						end
						return config[key]
					end
				})
			end
		end)
-- local conf = require "luci.config" 即可以获得main中所有配置信息
-- require("luci.config") 后追加了以下表
--[[
uci     		table: 0x1816300  /etc/config下文件操作函数                                         
luci   			table: 0x180c530  提供了debug config util 和 model几个表
__ubus_cb       table: 0x1801840  空表
__ubus_cb_event table: 0x17f6af0  空表
template        table: 0x1811da0  模板解析
ubus    		table: 0x180f8c0
]]--

--[[ _G.uci
add_history     function: 0x1816e40
add_delta       function: 0x1816bb0
set_confdir     function: 0x1816c10
save    function: 0x1816a10
__gc    function: 0x1816890
get_all function: 0x1816980
foreach function: 0x1816b30
delete  function: 0x1816a40
set_savedir     function: 0x1816c70
reorder function: 0x1816ad0
set     function: 0x18169e0
get_savedir     function: 0x1816c40
changes function: 0x1816b00
commit  function: 0x1816a70
get_confdir     function: 0x1816be0
cursor  function: 0x18168f0
revert  function: 0x1816aa0
unload  function: 0x1816920
rename  function: 0x1816b80
add     function: 0x18169b0
load    function: 0x18168c0
get     function: 0x1816950
]]--

--[[ luci
debug   table: 0x180c580
config  table: 0x180d7a0
util    table: 0x17fe340
model   table: 0x1816ca0
]]--

--[[ luci.config
_M      table: 0x180d7a0
_NAME   luci.config
_PACKAGE        luci.
]]--

--[[ ubus
STRING  3
close   function: 0x13d4530
send    function: 0x13d4ab0
__gc    function: 0x13d4ae0
ARRAY   1
call    function: 0x13d4500
INT16   6
INT64   4
BOOLEAN 7
INT8    7
objects function: 0x13d4440
reply   function: 0x13d44a0
listen  function: 0x13d4a80
TABLE   2
signatures      function: 0x13d44d0
connect function: 0x13d4410
INT32   5
add     function: 0x13d4470
]]--

--[[
> for k,v in pairs(template.parser) do
>> print(k,v)
>> end
hash    function: 0x13d1c60
utf8    function: 0x13d1a20
parse_string    function: 0x13d19c0
load_catalog    function: 0x13d1ae0
pcdata  function: 0x13d1a80
parse   function: 0x13d1960
translate       function: 0x13d1c00
change_catalog  function: 0x13d1ba0
close_catalog   function: 0x13d1b40
striptags       function: 0x13d1ab0
]]--
