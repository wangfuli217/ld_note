m = Map("network", "Network") -- 编辑/etc/config/network文件

s = m:section(TypedSection, "interface", "Interfaces") -- 指定"interface"类型章节
s.addremove = true -- 允许用户创建和移除interfaces章节
function s:filter(value)
   return value ~= "loopback" and value -- 过滤掉loopback
end 
s:depends("proto", "static") -- 仅显示proto参数值为static和dhcp的章节
s:depends("proto", "dhcp") 

p = s:option(ListValue, "proto", "Protocol") -- 创建一个下拉列表，用于修改proto参数值
p:value("static", "static") -- 添加列表值
p:value("dhcp", "DHCP")
p.default = "static" --列表默认值

s:option(Value, "ifname", "interface", "the physical interface to be used") -- 文本框，用于修改ifname参数值

s:option(Value, "ipaddr", translate("ip", "IP Address")) -- 文本框，用于修改ipaddr参数

s:option(Value, "netmask", "Netmask"):depends("proto", "static") --- 文本框，用于修改netmask参数，依赖于proto=static

mtu = s:option(Value, "mtu", "MTU")
mtu.optional = true -- 该选项是可选的，

dns = s:option(Value, "dns", "DNS-Server")
dns:depends("proto", "static") --依赖于proto=static
dns.optional = true            -- 该选项是可选的
function dns:validate(value)   ---- 验证值的合法性
    return value:match("[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+") --  匹配正则表达式
end

gw = s:option(Value, "gateway", "Gateway") --文本框，用于修改网关。依赖于proto=static
gw:depends("proto", "static")
gw.rmempty = true -- 如果为空则移除它

return m -- Returns the map