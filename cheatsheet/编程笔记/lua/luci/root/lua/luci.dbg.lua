#!/usr/bin/lua

require "nixio"

dbg = io.open("/tmp/luci.req", "w")

for k, v in pairs(nixio.getenv()) do
    dbg:write(string.format("export %s=%q\n", k, v))
end

dbg:write("/www/cgi-bin/luci\n")
dbg:close()
nixio.exec("/www/cgi-bin/luci")
