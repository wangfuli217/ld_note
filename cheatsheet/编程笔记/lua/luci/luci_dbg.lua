#!/usr/bin/lua
-- 存储环境变量 重新执行"/www/cgi-bin/luci"
-- POST类型环境变量如何传参... ...
-- https://github.com/seamustuohy/luci_tutorials/blob/master/06-debugging.md
require "nixio"

dbg = io.open("/tmp/luci.req", "w")

for k, v in pairs(nixio.getenv()) do
    dbg:write(string.format("export %s=%q\n", k, v))
end

dbg:write("/www/cgi-bin/luci\n")
dbg:close()
nixio.exec("/www/cgi-bin/luci")

-- Now change the url of the broken page from .../luci/... to .../luci.dbg/... and reload.
-- The script should create a file "/tmp/luci.req" which you can use to reproduce the same 
-- request on the command line:
-- root@OpenWrt:~# sh /tmp/luci.req