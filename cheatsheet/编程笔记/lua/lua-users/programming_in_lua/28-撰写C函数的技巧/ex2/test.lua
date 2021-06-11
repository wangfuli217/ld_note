--
-- Created by IntelliJ IDEA.
-- User: xinlei.fan
-- Date: 17/2/10
-- Time: 上午11:27
-- To change this template use File | Settings | File Templates.
--

local t = split("a:b:c\0:d",":")
for _,v in ipairs(t) do
    print(v)
end

