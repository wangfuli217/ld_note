--
-- Created by IntelliJ IDEA.
-- User: xinlei.fan
-- Date: 17/2/9
-- Time: 下午6:29
-- To change this template use File | Settings | File Templates.
--
local t = {11,12,13}
filter(t,function(v)
    return v+1
end)

for _,i in ipairs(t) do
    print(i)
end



