--
-- Created by IntelliJ IDEA.
-- User: xinlei.fan
-- Date: 17/2/14
-- Time: 下午4:41
-- To change this template use File | Settings | File Templates.
--
local mem = require("mem")
mem.setlimit(100000)
collectgarbage("collect")
print(mem.getused())
collectgarbage("collect")
print(collectgarbage("count") * 1024)
collectgarbage("collect")
print(mem.getgc())

