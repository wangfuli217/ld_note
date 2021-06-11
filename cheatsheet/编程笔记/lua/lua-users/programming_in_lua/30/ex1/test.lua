--
-- Created by IntelliJ IDEA.
-- User: xinlei.fan
-- Date: 17/2/13
-- Time: 下午5:55
-- To change this template use File | Settings | File Templates.
--

local dir = require("dir")
for f in dir.open("/Users/xinlei.fan/Documents/workspace/programming_in_lua/30/ex1") do
    print(f .. "\n")
end