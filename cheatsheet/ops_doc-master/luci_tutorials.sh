https://github.com/seamustuohy/luci_tutorials

/usr/lib/lua/luci/cbi.lua
/usr/lib/lua/luci/cbi/datatypes.lua
CBI(translate the UCI file into the HTML form){

流程为以下：
1、映射UCI文件
2、生成section
3、生成option
原config文件如下：
config login
    option username ''
    option password ''
    option ifname 'eth0'
    option domain ''
直接上代码：

require("luci.sys")

--[[

Map("配置文件文件名", "配置页面标题", "配置页面说明")，对应到配置文件/etc/config/testclient
]]--
m = Map("testclient", "the title of testclient", "the shuoming of testclient")

--[[

获取所有类型为login的section并生成html section
class可以是TypedSection表示根据类型获取section
NamedSection表示根据名字获取section
]]--

s = m:section(TypedSection, "login", "")
s.addremove = false
s.anonymous = true
--[[

生成option

class可以是：

Value：input控件

ListValue：下拉列表
Flag：选择框
MultiValue:
DummyValue：纯文本
TextValue：多行input
Button：按钮
StaticList：
DynamicList:

下代码为每个section生成可选项控件，映射到proto字段
p= s:option(ListValue, "proto", "Protocol")
p:value("static", "static")
p:value("dhcp", "DHCP")
p.default = "static"
]]--

enable = s:option(Flag, "enable", translate("Enable"))
name = s:option(Value, "username", translate("Username"))
pass = s:option(Value, "password", translate("Password"))
pass.password = true
domain = s:option(Value, "domain", translate("Domain"))

ifname = s:option(ListValue, "ifname", translate("Interfaces"))
for k, v in ipairs(luci.sys.NET.devices()) do
    if v ~= "lo" then
        ifname:value(v)
    end
end
local apply = luci.http.formvalue("cbi.apply")
if apply then
    io.popen("/etc/init.d/njitclient restart")
end

return m


控件对应的html文件在luasrc\view\cbi目录下
}

root(){
/usr/lib/lua/luci/
RESOURCES: /www/luci-static/resources/
MEDIA: /www/luci-static/commotion/
}

/etc/config/luci 
config(The LuCI config file){
'core' 'main': These are the basic settings for things like setting the default directories, turning on the network interface unit and setting the language.

'extern' 'flash_keep': The files to keep when sysupgrade is run with save-settings. See: https://forum.openwrt.org/viewtopic.php?id=23194 for more info on customization

'internal' 'languages': The abbreviations that represent the supported translations in LuCI translate.

'internal' 'sauth': Defines where sessions are stored and how long they last for logged in admin users.

'internal' 'ccache': LuCI module caching. See: 06-debugging module of this repo for an in depth overview.

'internal' 'themes': The current themes that LuCI knows about. You should not have to touch this.
}

luci(api){
# The LuCI API
https://htmlpreview.github.io/?https://github.com/openwrt/luci/blob/master/documentation/api/index.html
#　Nixio　API
https://htmlpreview.github.io/?https://github.com/openwrt/luci/blob/master/documentation/api/index.html
#　Nixio　Source
http://luci.subsignal.org/trac/browser/luci/trunk/libs/nixio
}

init(Config file for init-scripts and dependences){
/etc/config/unitrack
}

file(Main LuCI controller Files){
/usr/lib/lua/luci/*.lua files

asterisk.lua :runs asterisk functions http://luci.subsignal.org/api/luci/modules/luci.asterisk.html
cacheloader.lua : simply uses config.lua to check the luci uci file and if on loads ccache.cache_ondemand()
cbi.lua : The library that handles binding configuration values to UCI data.
ccache.lua : enables caching (and if cache_ondemand() runs the S values of debugging output for one level of introspection with debug.getinfo on errors. see: http://pgl.yoyo.org/luai/i/lua_getinfo)
config.lua : reads configuration values from the luci uci file
debug.lua : Runs debugging commands. See: module 06-debugging for more info.
dispatcher.lua : The library that control the http requests, page loading, and basic controller... controlling. http://luci.subsignal.org/api/luci/modules/luci.dispatcher.html
fs.lua : The lua file system library. http://luci.subsignal.org/api/luci/modules/luci.fs.html
httpclient.lua : Library that implements the client side of required http standards like Get and more
http.lua : LuCI Web Framework high-level HTTP functions. http://luci.subsignal.org/api/luci/modules/luci.http.html
i18n.lua : LuCi translation library http://luci.subsignal.org/api/luci/modules/luci.i18n.html
init.lua : The main LuCI initialization module.
ip.lua : LuCI IP calculation library. http://luci.subsignal.org/api/luci/modules/luci.ip.html
json.lua : LuCI JSON-Library http://luci.subsignal.org/api/luci/modules/luci.json.html
jsonrpc.lua : an implementation of a json remote procedure call protocol similar to XML-RPC.
ltn12.lua (With an L at the front): The Lua Socket Toolkit http://luci.subsignal.org/api/luci/modules/luci.ltn12.html http://luci.subsignal.org/api/luci/modules/luci.ltn12.filter.html http://luci.subsignal.org/api/luci/modules/luci.ltn12.pump.html http://luci.subsignal.org/api/luci/modules/luci.ltn12.sink.html http://luci.subsignal.org/api/luci/modules/luci.ltn12.source.html
lucid.lua : A superprocess / child process / daemon manager that has the ability to work with rpc, http, and other networking services. -> I have yet to dig in to this but we should http://luci.subsignal.org/api/luci/modules/luci.lucid.html
niulib.lua : A library that allows you to get a list of available (and bridged) ethernet and wireless interfaces.
rpcc.lua : LuCI RPC Client. http://luci.subsignal.org/api/luci/modules/luci.rpcc.html
sauth.lua : The library that controls user sessions. http://luci.subsignal.org/api/luci/modules/luci.sauth.html
store.lua : A module that is simple an instance of util.threadlocal(). Donot ask me... http://luci.subsignal.org/api/luci/modules/luci.util.html#threadlocal
sys.lua : LuCI Linux and POSIX system utilities. http://luci.subsignal.org/api/luci/modules/luci.sys.html
template.lua : A template parser supporting includes, translations, lua code blocks, and more. It can be set as either a compiler or as an interpreter.
util.lua : The LuCI utility functions library. http://luci.subsignal.org/api/luci/modules/luci.util.html
version.lua : Module that gets/gives the Lua/LuCI versions
}

cbi(The CBI Call){
cbi("path/to/cbi", {"config values"})

The Following config vallues are allowed:

    on_success_to If set this will redirect to the node passed it upon a form value returning that it was valid, done, changed or skipped (see:cbi-form values)

    on_changed_to If set this will redirect to the node passed it upon a form value returning that it was changed or skipped (see:cbi-form values)

    on_valid_to If set this will redirect to the node passed it upon a form value returning that it was valid, or done (see:cbi-form values)

    noheader If set this will cause a CBI page to be rendered without the CBI header (which contains the start of the form that all CBI values are contained within) and without the OpenWRT Theme header.

    nofooter If set this will cause a CBI page to be rendered without the CBI footer (which contains the CBI submission buttons) and without the OpenWRT Theme footer.

    autoapply

    hideresetbtn Hide the reset button on the footer

    hideapplybtn Hide the apply button on the footer

    hidesavebtn hide the save button on the footer

    skip Add the skip button on the footer (really only useful if you are making a flow/deligator based config.)
}