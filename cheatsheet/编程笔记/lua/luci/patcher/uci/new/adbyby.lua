--Mr.Z<zenghuaguo@hotmail.com>
local NXFS = require "nixio.fs"
local SYS  = require "luci.sys"
local HTTP = require "luci.http"
local DISP = require "luci.dispatcher"

local m,s,o
local LUCI_VER,ADBYBY_VER,Status

if SYS.call("pidof adbyby >/dev/null") == 0 then
	Status = "<strong><font color=\"green\">广告屏蔽大师 Plus + 运行中</font></strong>"
else
	Status = "<strong><font color=\"red\">广告屏蔽大师 Plus + 未运行</font></strong>"
end

m = Map("adbyby")
m.title	= translate("广告屏蔽大师 Plus +")
m.description = translate(string.format("广告屏蔽大师 Plus + 可以全面过滤各种横幅、弹窗、视频广告，同时阻止跟踪、隐私窃取及各种恶意网站<br /><font color=\"red\">Plus + 版本可以和 Adblock Plus Host 结合方式运行，过滤广告不损失带宽</font><br /><br />%s", Status))

s = m:section(TypedSection, "adbyby")
s.anonymous = true


--基本设置
s:tab("basic",  translate("基本设置"))

up = s:taboption("basic", Button, "update211","强制开启","<font color=\"red\">强制开启，可点此按钮后刷新浏览器</font></strong>")
up.inputstyle = "apply"
up.write = function(call)
	luci.sys.call("/etc/sh/adbyby_start &")
end

up = s:taboption("basic", Button, "update212","强制关闭","<font color=\"red\">强制开启，可点此按钮后刷新浏览器</font></strong>")
up.inputstyle = "apply"
up.write = function(call)
	luci.sys.call("/etc/sh/adbyby_stop &")
end

o = s:taboption("basic", Flag, "enable")
o.title = translate("启用")
o.default = 0
o.rmempty = false

o = s:taboption("basic", ListValue, "daemon")
o.title = translate("守护进程")
o:value("0", translate("禁用"))
o:value("1", translate("脚本监视"))
o:value("2", translate("内置监视"))
o.default = 2
o.rmempty = false



o = s:taboption("basic", ListValue, "wan_mode")
o.title = translate("运行模式")
o:value("0", translate("全局过滤模式（速度最慢，效果最好）"))
o:value("1", translate("Plus + 模式（过滤域名列表和黑名单网站，推荐）"))
o:value("2", translate("白名单模式（过滤域名列表以外所有网站）"))
o.default = 0
o.rmempty = false

o = s:taboption("basic", Button, "proxy")
o.title = translate("透明代理")
if SYS.call("iptables-save | grep ADBYBY >/dev/null") == 0 then
	o.inputtitle = translate("点击关闭")
	o.inputstyle = "reset"
	o.write = function()
		SYS.call("/etc/init.d/adbyby del_rule")
		HTTP.redirect(DISP.build_url("admin", "control", "adbyby"))
	end
else
	o.inputtitle = translate("点击开启")
	o.inputstyle = "apply"
	o.write = function()
		SYS.call('[ -n "$(pgrep adbyby)" ] && /etc/init.d/adbyby add_rule')
		HTTP.redirect(DISP.build_url("admin", "control", "adbyby"))
	end
end


local DL = SYS.exec("head -1 /usr/share/adbyby/data/lazy.txt | awk -F' ' '{print $3,$4}'")
local DV = SYS.exec("head -1 /usr/share/adbyby/data/video.txt | awk -F' ' '{print $3,$4}'")
local NR = SYS.exec("grep -v '^!' /usr/share/adbyby/data/rules.txt | wc -l")
local NU = SYS.exec("cat /usr/share/adbyby/data/user.txt | wc -l")
local NW = SYS.exec("uci get adbyby.@adbyby[-1].domain 2>/dev/null | wc -l")
local ND = SYS.exec("cat /usr/share/adbyby/dnsmasq.adblock | wc -l")

o = s:taboption("basic", Button, "restart")
o.title = translate("规则状态")
o.inputtitle = translate("重启更新")
o.description = translate(string.format("规则日期/条目：<br /><strong>Lazy规则：</strong>%s <strong>&nbsp;&nbsp;Video规则：</strong>%s<br /><strong>第三方订阅规则：</strong>%d 条&nbsp;&nbsp;<strong>自定义规则：</strong>%d 条", DL, DV, math.abs(NR+NW-NU), NR))
o.inputstyle = "reload"
o.write = function()
	SYS.call("/etc/init.d/adbyby restart")
	HTTP.redirect(DISP.build_url("admin", "control", "adbyby"))
end


--技术支持
s:tab("help",  translate("域名列表"), "/usr/share/adbyby/adhost.conf")

local conf = "/usr/share/adbyby/adhost.conf"
o = s:taboption("help", TextValue, "conf")
o.description = translate("（!）注意写入域名即可，例如 http://www.baidu.com 只需要写入 baidu.com，一行一个")
o.rows = 13
o.wrap = "off"
o.cfgvalue = function(self, section)
	return NXFS.readfile(conf) or ""
end
o.write = function(self, section, value)
	NXFS.writefile(conf, value:gsub("\r\n", "\n"))
	SYS.call("/etc/init.d/adbyby restart")
end




--高级设置
s:tab("advanced", translate("高级设置"))

o = s:taboption("advanced", Flag, "cron_mode")
o.title = translate("每天凌晨6点更新规则并重启")
o.default = 0
o.rmempty = false

updatead = s:taboption("advanced", Button, "updatead", translate("手动强制更新<br />Adblock Plus Host 列表"), translate(string.format("<strong><font color=\"blue\">Adblock Plus Host 规则：</font></strong>/usr/share/adbyby/dnsmasq.adblock %s条<br />注意：因为需要下载并转换规则，后台可能需要60-120秒时间运行，请勿重复点击<br />/tmp/adupdate.log", ND)))
updatead.inputtitle = translate("手动强制更新")
updatead.inputstyle = "apply"
updatead.write = function()
	SYS.call("sh /usr/share/adbyby/adblock.sh > /tmp/adupdate.log 2>&1 &")
end

o = s:taboption("advanced", DynamicList, "exrule")
o.title = translate("第三方规则订阅（不推荐）")
o.placeholder = "[https|http|ftp]://[Hostname]/[File]"

o = s:taboption("advanced", ListValue, "lan_mode")
o.title = translate("内网客户端过滤控制")
o:value("0", translate("全部客户端过滤"))
o:value("1", translate("仅过滤IP列表内客户端"))
o:value("2", translate("不过滤IP列表内客户端"))
o.default = 0
o.rmempty = false

o = s:taboption("advanced", DynamicList, "lan_ip")
o.title = translate("内网IP列表")
o.datatype = "ipaddr"
o.placeholder = "IP address | IP/Mask"
for i,v in ipairs(SYS.net.arptable()) do
	o:value(v["IP address"])
end
o:depends("lan_mode", 1)
o:depends("lan_mode", 2)

o = s:taboption("advanced", DynamicList, "domain")
o.title = translate("在这些域名禁用去广告")
o.placeholder = "google.com"



--自定义规则
s:tab("user", translate("自定义规则"),"/usr/share/adbyby/data/rules.txt")

local file = "/usr/share/adbyby/data/rules.txt"
o = s:taboption("user", TextValue, "rules")
o.description = translate("开头感叹号（!）的每一行被视为注释。")
o.rows = 13
o.wrap = "off"
o.cfgvalue = function(self, section)
	return NXFS.readfile(file) or ""
end
o.write = function(self, section, value)
	NXFS.writefile(file, value:gsub("\r\n", "\n"))
end


return m
