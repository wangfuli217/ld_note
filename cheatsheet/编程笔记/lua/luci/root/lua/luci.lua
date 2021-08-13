#!/usr/bin/lua  --cgi的执行命令的路径 
require "luci.cacheloader" --导入cacheloader包 
require "luci.sgi.cgi"     --导入sgi.cgi包  
luci.dispatcher.indexcache = "/tmp/luci-indexcache" --cache缓存路径地址 
luci.sgi.cgi.run() --执行run，此方法位于*/luci/sgi/cgi.lua中


--[[
1、浏览器敲入192.168.1.1后就，路由器作为uhttp server会把/www/index.html这个页面返回给浏览器，
   而且这个页面又会刷新， 去请求页面/luci/cgi，代码如红色标记：
   <metahttp-equiv="refresh" content="0; URL=/cgi-bin/luci" />
2. wget 192.168.101.1 可以清楚看到返回页面就是 /www/index.html 这个页面
   或通过firefox的隐私页面+wireshark抓包也可以得到 /www/index.html 这个页面
]]
